class CreateCurrentLocations < ActiveRecord::Migration
  def change
    create_table :current_locations do |t|
      t.string :uuid, null: false, default: ''
      t.string :device, null: false, default: ''
      t.timestamps null: false
    end
  end
end
