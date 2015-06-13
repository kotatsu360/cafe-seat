class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :uuid, null: false, default: ''
      t.string :device, null: false, default: ''
      t.integer :price, null: false, default: 0
      t.timestamps null: false
    end
  end
end
