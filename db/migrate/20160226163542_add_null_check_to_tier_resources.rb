class AddNullCheckToTierResources < ActiveRecord::Migration[5.0]
  def change
    change_column :tier_resources, :resource_id, :integer, null: false
  end
end
