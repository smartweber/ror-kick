class DropResourcesTiersTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :resources_tiers
  end
end
