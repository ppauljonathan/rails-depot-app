class AddLineItemsCountToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :line_items_count, :integer, default: 0
  end
end
