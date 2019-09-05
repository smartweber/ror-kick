class ChangeBaseCostInTiers < ActiveRecord::Migration[5.0]
  def up
    change_column :tiers, :base_cost, :decimal, null: true
  end

  def down
    change_column :tiers, :base_cost, :decimal, null: false
  end
end
