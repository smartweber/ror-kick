class AddKickByHideResourcesHideTotalRaisedToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :kick_by, :integer, :default => 1
    add_column :events, :show_resources, :boolean, :default => true
    add_column :events, :show_dollars, :boolean, :default => true
  end
end
