class AddNamesToTimeEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :name, :string
    add_column :time_entries, :project_name, :string
    add_column :time_entries, :task_name, :string
  end
end
