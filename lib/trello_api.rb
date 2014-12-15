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
    fields = ['name', 'desc', 'shortLink', 'shortUrl'].join(',')
    board_ids.inject([]) do |all_cards, board_id|
      board_cards = client.get board_cards_path(board_id), fields: fields
      board_cards = add_time_info(JSON.parse(board_cards))
      all_cards.concat board_cards
    end
  end

  private

  def add_time_info(cards)
    cards.map do |card|
      parser = Trello::CardParser.new(card['name'])
      card['actual']   = parser.get_actual
      card['estimate'] = parser.get_estimate
      card
    end
  end


  def json_value(res)
    json = JSON.parse(res)

    return json['_value'] if json['_value'].present?

    json
  end

  def board_cards_path(id)
    "/boards/#{id}/cards"
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
end
