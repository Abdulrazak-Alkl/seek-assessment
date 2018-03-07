class CreateCarts < ActiveRecord::Migration[5.1]
  def change
    create_table :carts do |t|
      t.integer :customer_id
      t.string :items
      t.float :total, default: 0
      t.float :total_discount, default: 0
      t.timestamps
    end
  end
end
