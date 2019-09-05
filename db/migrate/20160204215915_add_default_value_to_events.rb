class AddDefaultValueToEvents < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :event_type_id, :integer, :default => 0
  end
end
