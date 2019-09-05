class AddColumnsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :slug, :string
    add_column :events, :location_name, :string
    add_column :events, :location_address, :string
    add_column :events, :contact_email, :string
    add_column :events, :contact_phone, :string
    add_column :events, :start, :datetime
    add_column :events, :end, :datetime
    add_column :events, :deadline, :datetime
    add_column :events, :attendee_count, :integer
    add_column :events, :contribution, :decimal
    add_column :events, :contribution_note, :string
  end
end
