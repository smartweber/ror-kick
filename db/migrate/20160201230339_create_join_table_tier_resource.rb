class CreateJoinTableTierResource < ActiveRecord::Migration[5.0]
  def change
    create_join_table :tiers, :resources do |t|
      # t.index [:tier_id, :resource_id]
      # t.index [:resource_id, :tier_id]
      t.decimal :price, :precision => 8, :scale => 2, :default => 0.00, null: false

      t.timestamps
    end
  end
end
