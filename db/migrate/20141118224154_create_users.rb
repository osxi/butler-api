class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.integer :fb_staff_id
      t.string  :trello_username

      t.timestamps
    end

    create_table :users_teams do |t|
      t.belongs_to :user
      t.belongs_to :team
      t.timestamps
    end
  end
end
