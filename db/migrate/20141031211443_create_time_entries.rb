class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.integer :fb_id
      t.integer :fb_project_id
      t.integer :fb_task_id
      t.integer :fb_staff_id
      t.text :notes
      t.float :hours
      t.date :date
      t.string :trello_card_id, index: true

      t.timestamps
    end
  end
end
