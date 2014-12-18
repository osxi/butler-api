module Trello
  class Reporter < Struct.new(:client)
    def report(board_ids: [])
      cards_for_board_ids(board_ids).map { |card| underscore_keys card }
    end

    def date_from_id(id)
      timestamp = id.to_s[0..7].to_i(16)
      Time.at(timestamp).to_datetime
    end

    private

    def cards_for_board_ids(board_ids)
      board_ids.inject([]) do |all_cards, board_id|
        cards = cards_for_board_id(board_id)
        all_cards.concat parse_cards(cards, board_id)
      end
    end

    def cards_for_board_id(board_id)
      trello_response = client.get "/boards/#{board_id}/cards",
                                  fields: card_fields
      JSON.parse trello_response
    end

    def parse_cards(cards, board_id)
      remove_unwanted_fields add_extra_fields(cards, board_id)
    end

    def card_fields
      ['name', 'desc', 'shortLink', 'shortUrl'].join(',')
    end

    def add_extra_fields(cards, board_id)
      board_name = get_board_name board_id

      cards.map do |card|
        card = add_time_info card

        card['createdAt']  = date_from_id(card['id'])
        card['board_id']   = board_id
        card['board_name'] = board_name

        card
      end
    end

    def add_time_info(card)
      parser = Trello::CardParser.new(card['name'])
      card['actual']   = parser.get_actual
      card['estimate'] = parser.get_estimate
      card
    end

    def remove_unwanted_fields(cards)
      cards.map { |card| card.except('id') }
    end

    def get_board_name(board_id)
      trello_response = client.get "/boards/#{board_id}/name"
      JSON.parse(trello_response)['_value']
    end

    def underscore_keys(card)
      card.keys.each_with_object({}) do |key, result|
        result[key.underscore] = card[key]
      end
    end
  end
end
