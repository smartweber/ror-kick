class CreateEmailsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.references :event, foreign_key: true
      t.string :subject
      t.string :body
      t.integer :created_by

      t.timestamps
    end
  end
end
