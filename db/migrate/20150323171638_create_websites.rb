class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :name
      t.string :url
      t.boolean :live
      t.datetime :ping

      t.timestamps
    end
  end
end
