class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers do |t|
      t.integer :usage_limit
      t.integer :customer_id
      t.integer :price_rule_id
      t.datetime :starts_at
      t.datetime :ends_at
      t.timestamps
    end
  end
end
