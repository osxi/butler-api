module Trello
  class CardActualsUpdater < Struct.new(:trello_client)
    def update_card(card_id)
      hours = records_for_card(card_id).sum(:hours)

      did_update = trello_client.update_card_hours(card_id, hours)
      comment_total_hours(card_id, hours) if did_update
    end

    def update_cards(*card_ids)
      # How can I do this?
      # card_ids.each(&:update_card)
      card_ids.each { |card_id| update_card(card_id) }
    end

    private

    def comment_total_hours(card_id, hours)
      comment = "Actual hours changed to #{hours}"
      trello_client.create_comment(card_id, comment)
    end

    def records_for_card(card_id)
      TimeEntry.where(trello_card_id: card_id)
    end
  end
end
