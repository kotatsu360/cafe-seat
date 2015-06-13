class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :uuid, null: false, default: ''
      t.string :name, null: false, default: ''
      t.timestamps null: false
    end
  end
end
