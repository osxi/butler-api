class CreateProjectsUsers < ActiveRecord::Migration
  def change
    create_table :projects_users do |t|
      t.references :user
      t.references :project
      t.timestamps
    end
  end
end
