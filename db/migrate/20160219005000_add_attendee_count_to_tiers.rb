class AddAttendeeCountToTiers < ActiveRecord::Migration[5.0]
  def change
    add_column :tiers, :attendee_count, :integer, :default => 0
  end
end
