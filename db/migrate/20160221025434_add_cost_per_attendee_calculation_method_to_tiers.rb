class AddCostPerAttendeeCalculationMethodToTiers < ActiveRecord::Migration[5.0]
  def change
    add_column :tiers, :cost_per_attendee, :decimal, :precision => 8, :scale => 2
    add_column :tiers, :calculation_method, :integer, :default => 1 # calculate it for me
  end
end
