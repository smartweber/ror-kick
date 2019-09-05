class AddNullCheckToStartDeadlineOnEvents < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :start, :datetime, null: false
    change_column :events, :deadline, :datetime, null: false
  end
end
