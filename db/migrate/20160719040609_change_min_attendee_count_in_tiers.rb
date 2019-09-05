class ChangeMinAttendeeCountInTiers < ActiveRecord::Migration[5.0]
  def up
    change_column :tiers, :min_attendee_count, :integer, default: 0, null: true
  end

  def down
    change_column :tiers, :min_attendee_count, :integer, default: 0, null: false
  end
end
