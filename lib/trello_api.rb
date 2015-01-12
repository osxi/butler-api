require 'trello'

class TrelloApi
  attr_accessor :client

  def initialize(developer_public_key, member_token)
    @client = Trello::Client.new(
              developer_public_key: developer_public_key,
              member_token: member_token)
  end

  def update_card_hours(card_id, total_hours)
    name                    = get_card_name(card_id)
    name_with_updated_hours = update_hours_in_name(name, total_hours)

    if name == name_with_updated_hours
      false
    else
      set_card_name(card_id, name_with_updated_hours)
    end
  rescue Trello::Error => e
    notify_airbrake e
    false
  end

  def get_card_name(card_id)
    res = client.get card_name_path(card_id)
    json_value res
  end

  def set_card_name(card_id, name)
    client.put card_name_path(card_id), value: name
    name
  end

  def create_comment(card_id, comment)
    client.post "#{card_path(card_id)}/actions/comments", text: comment
    comment
  end

  def report(board_ids: [])
    Trello::Reporter.new(client).report(board_ids: board_ids)
  end

  private

  def json_value(res)
    json = JSON.parse(res)

    return json['_value'] if json['_value'].present?

    json
  end

  def card_name_path(id)
    "#{card_path(id)}/name"
  end

  def card_path(id)
    "/cards/#{id}"
  end

  def update_hours_in_name(name, total_hours)
    Trello::CardParser.new(name).update_hours_in_name(total_hours)
  end

  def notify_airbrake(err)
    Airbrake.notify(err)
  end
end
