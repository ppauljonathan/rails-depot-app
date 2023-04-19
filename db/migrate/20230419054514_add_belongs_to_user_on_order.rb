class AddBelongsToUserOnOrder < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :orders, :user, foreign_key: true
  end
end
