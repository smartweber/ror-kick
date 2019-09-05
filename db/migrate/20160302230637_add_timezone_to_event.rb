class AddTimezoneToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :timezone_offset, :integer, :default => 0
    add_column :events, :timezone_name, :string, :default => 'UTC'
  end
end
