class AddLanguagePreferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :language_preference, :string, default: 'en'
  end
end
