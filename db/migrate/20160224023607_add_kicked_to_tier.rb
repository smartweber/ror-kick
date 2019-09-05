class AddKickedToTier < ActiveRecord::Migration[5.0]
  def change
    add_column :tiers, :kicked, :boolean, :default => false
  end
end
