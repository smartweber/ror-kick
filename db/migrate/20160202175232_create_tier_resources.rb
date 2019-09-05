class CreateTierResources < ActiveRecord::Migration[5.0]
  def change
    create_table :tier_resources do |t|
      t.decimal :price, :precision => 8, :scale => 2, :default => 0.00, null: false

      t.timestamps
    end
  end
end
