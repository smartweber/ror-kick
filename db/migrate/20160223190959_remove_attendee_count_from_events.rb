class RemoveAttendeeCountFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :attendee_count, :integer
  end
end
