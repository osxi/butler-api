class RemoveUnusedStringsFromTimeEntries < ActiveRecord::Migration
  def change
    remove_columns :time_entries, :project_name, :task_name, :name
  end
end
