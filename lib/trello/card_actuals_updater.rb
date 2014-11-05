module Trello
  class CardActualsUpdater < Struct.new(:trello_client)
    def update_card(card_id)
      hours = records_for_card(card_id).sum(:hours)

      trello_client.update_card_hours(card_id, hours)
    end

    def update_cards(*card_ids)
      # How can I do this?
      # card_ids.each(&:update_card)
      card_ids.each { |card_id| update_card(card_id) }
    end

    private

    def records_for_card(card_id)
      TimeEntry.where(trello_card_id: card_id)
    end
  end
end
