class AddIndexToTrelloCardIdOnTimeEntries < ActiveRecord::Migration
  def change
    add_index :time_entries, :trello_card_id
  end
end
