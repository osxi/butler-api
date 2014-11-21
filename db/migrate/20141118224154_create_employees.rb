class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.integer :fb_staff_id
      t.string  :trello_username

      t.timestamps
    end

    create_table :employees_teams do |t|
      t.belongs_to :employee
      t.belongs_to :team
      t.timestamps
    end
  end
end
