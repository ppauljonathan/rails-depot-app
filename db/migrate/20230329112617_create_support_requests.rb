class CreateSupportRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :support_requests do |t|
      t.string :email, comment: 'email of submitter'
      t.string :subject, comment: 'subject of email'
      t.text :body, comment: 'body of support email'

      t.references :order,
        foreign_key: true,
        comment: 'most recent order'

      t.timestamps
    end
  end
end
