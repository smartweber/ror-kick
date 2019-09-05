class AddBaseCostMaxAttendeesToTiers < ActiveRecord::Migration[5.0]
  def change
    add_column :tiers, :max_attendee_count, :integer, :default => 0
    add_column :tiers, :base_cost, :decimal, :precision => 8, :scale => 2, :default => 0.00, null: false
  end
end
