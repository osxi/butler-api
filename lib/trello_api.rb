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
    cards = board_ids.inject([]) do |all_cards, board_id|
      board_cards = client.get board_cards_path(board_id), fields: fields
      all_cards.concat JSON.parse(board_cards)
    end

    remove_unwanted_fields add_non_default_fields(cards)
  end

  def date_from_id(id)
    timestamp = id.to_s[0..7].to_i(16)
    Time.at(timestamp).to_datetime
  end

  private

  def remove_unwanted_fields(cards)
    cards.map do |card|
      card.except('id')
    end
  end

  def add_non_default_fields(cards)
    cards.map do |card|
      card = add_time_info(card)
      card = add_created_at(card)
      card
    end
  end

  def add_time_info(card)
    parser = Trello::CardParser.new(card['name'])
    card['actual']   = parser.get_actual
    card['estimate'] = parser.get_estimate
    card
  end

  def add_created_at(card)
    card['createdAt'] = date_from_id(card['id'])
    card
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
