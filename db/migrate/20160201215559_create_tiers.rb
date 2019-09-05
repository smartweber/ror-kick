class CreateTiers < ActiveRecord::Migration[5.0]
  def change
    create_table :tiers do |t|
      t.string :name
      t.string :description
      t.integer :threshold, default: 0, null: false
      t.string :profile_img
      t.decimal :contribution, :precision => 8, :scale => 2, :default => 0.00, null: false
      t.string :contribution_note

      t.timestamps
    end
  end
end
