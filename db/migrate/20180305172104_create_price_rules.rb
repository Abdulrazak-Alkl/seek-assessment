class CreatePriceRules < ActiveRecord::Migration[5.1]
  def change
    create_table :price_rules do |t|
      t.string :title
      t.string :value_type
      t.float  :value
      t.string :target_selection
      t.string :allocation_method
      t.integer :prerequisite_minimum_items
      t.float :prerequisite_minimum_subtotal
      t.string :entitled_products_skus
      t.timestamps
    end
  end
end
