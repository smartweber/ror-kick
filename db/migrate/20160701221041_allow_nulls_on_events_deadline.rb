class AllowNullsOnEventsDeadline < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :deadline, :datetime, null: true
  end
end
