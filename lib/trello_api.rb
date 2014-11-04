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

    set_card_name(card_id, name_with_updated_hours)
  end

  def get_card_name(card_id)
    res = client.get card_name_path(card_id)
    json_value res
  end

  def set_card_name(card_id, name)
    client.put card_name_path(card_id), value: name
    name
  end

  private

  def json_value(res)
    json = JSON.parse(res)

    return json['_value'] if json['_value'].present?

    json
  end

  def card_name_path(id)
    "/cards/#{id}/name"
  end

  def update_hours_in_name(name, total_hours)
    split_regex = /(.*\[)([\d\.]+)(\].*)\s?$/

    split_name = name.to_s.split(split_regex)

    if split_name && split_name.length == 4
      split_name.shift
      split_name[1] = total_hours.round(2)
      split_name.join
    else
      "#{name} [#{total_hours.round(2)}]"
    end
  end
end
