class AddColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    change_table :products do |t|
      t.boolean :enabled
      t.decimal :discount_price, precision: 8, scale: 2
      t.string :permalink
    end
  end
end
