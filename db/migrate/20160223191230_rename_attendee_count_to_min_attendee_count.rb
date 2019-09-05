class RenameAttendeeCountToMinAttendeeCount < ActiveRecord::Migration[5.0]
  def change
    rename_column :tiers, :attendee_count, :min_attendee_count
  end
end
