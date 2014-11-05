module Trello
  class CardActualsUpdater < Struct.new(:trello_client)
    def update_card(card_id, update_from_freshbooks:false)
      run_freshbooks_update if update_from_freshbooks

      hours = records_for_card(card_id).sum(:hours)

      trello_client.update_card_hours(card_id, hours)
    end

    private

    def records_for_card(card_id)
      TimeEntry.where(trello_card_id: card_id)
    end
  end
end
