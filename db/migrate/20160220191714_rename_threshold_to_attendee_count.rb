class RenameThresholdToAttendeeCount < ActiveRecord::Migration[5.0]
  def change
    rename_column :tiers, :threshold, :attendee_count
  end
end
