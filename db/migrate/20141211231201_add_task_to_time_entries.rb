class AddTaskToTimeEntries < ActiveRecord::Migration
  def change
    add_reference :time_entries, :task, index: true
  end
end
