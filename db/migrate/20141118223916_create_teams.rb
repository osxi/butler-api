class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name

      t.timestamps
    end

    create_table :teams_employees do |t|
      t.belongs_to :team
      t.belongs_to :employee
      t.timestamps
    end
  end
end
