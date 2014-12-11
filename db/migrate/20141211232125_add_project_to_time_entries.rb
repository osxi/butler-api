class AddProjectToTimeEntries < ActiveRecord::Migration
  def change
    add_reference :time_entries, :project, index: true
  end
end
