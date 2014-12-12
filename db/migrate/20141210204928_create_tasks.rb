class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :project_id
      t.integer :fb_task_id
      t.integer :user_id

      t.timestamps
    end
  end
end
