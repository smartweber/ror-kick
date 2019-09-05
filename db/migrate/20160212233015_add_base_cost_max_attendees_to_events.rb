class AddBaseCostMaxAttendeesToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :max_attendee_count, :integer, :default => 0
    add_column :events, :base_cost, :decimal, :precision => 8, :scale => 2, :default => 0.00, null: false
  end
end
