class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :state
      t.string :city
      t.string :country
      t.string :pincode
      t.belongs_to :addressable, polymorphic: true

      t.timestamps
    end
  end
end
