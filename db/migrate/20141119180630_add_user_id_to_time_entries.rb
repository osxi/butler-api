class AddUserIdToTimeEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :user_id, :integer
  end
end
