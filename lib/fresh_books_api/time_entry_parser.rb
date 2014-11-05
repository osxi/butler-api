module FreshBooksApi
  class TimeEntryParser < Struct.new(:notes)
    CARD_ID_REGEX = /\(trello:([\w]{8})\)/

    def card_id
      matches = notes.match(CARD_ID_REGEX)

      return matches[1] if matches && matches.length > 1

      :no_card_id_found
    end
  end
end
