class AddLatLngStatusToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :location_lat, :decimal, {:precision=>10, :scale=>6}
    add_column :events, :location_lng, :decimal, {:precision=>10, :scale=>6}
    add_column :events, :status, :integer, :default => 1
  end
end
