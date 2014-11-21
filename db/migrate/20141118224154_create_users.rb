class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.integer :fb_staff_id
      t.string  :trello_username
      t.integer :team_id

      t.timestamps
    end
  end
end
