class AddEventRefToTiers < ActiveRecord::Migration[5.0]
  def change
    add_reference :tiers, :event, index: true, foreign_key: true
  end
end
