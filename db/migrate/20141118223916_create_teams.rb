class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name

      t.timestamps
    end

    create_table :teams_users do |t|
      t.belongs_to :team
      t.belongs_to :user
      t.timestamps
    end
  end
end
