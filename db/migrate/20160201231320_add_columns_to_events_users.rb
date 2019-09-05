class AddColumnsToEventsUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :events_users, :status, :integer
    add_column :events_users, :relation, :integer
  end
end
