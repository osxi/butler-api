class CreateProjectTasks < ActiveRecord::Migration
  def change
    create_table :project_tasks do |t|
      t.references :project
      t.references :task

      t.timestamps
    end
  end
end
