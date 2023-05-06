class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, unique: true, index: true, null: false
      t.belongs_to :parent, foreign_key: { to_table: :categories }, null: true

      t.timestamps
    end
  end
end
