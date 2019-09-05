class AddReferencesToTierResources < ActiveRecord::Migration[5.0]
  def change
    add_reference :tier_resources, :tier, index: true, foreign_key: true
    add_reference :tier_resources, :resource, index: true, foreign_key: true
  end
end
