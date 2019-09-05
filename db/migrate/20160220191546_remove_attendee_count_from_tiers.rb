class RemoveAttendeeCountFromTiers < ActiveRecord::Migration[5.0]
  def change
    remove_column :tiers, :attendee_count, :integer
  end
end
