class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :object_type, foreign_key: true
      t.integer :object_id

      t.timestamps
    end
  end
end
