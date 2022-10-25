class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.string :link, null: false
      t.string :shortener, null: false
      t.datetime :expiration_time, null: false

      t.timestamps
    end
  end
end
