class RemoveMaxAttendeeBaseCostFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :max_attendee_count
    remove_column :events, :base_cost
  end
end
