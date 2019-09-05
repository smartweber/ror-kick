class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.string :from
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.string :to
      t.string :to_name
      t.string :subject
      t.string :body
      t.boolean :sent, default: false
      t.boolean :read, default: false
      t.integer :created_by

      t.timestamps
    end
  end
end
