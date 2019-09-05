class AddEventTypeRefToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :event_type, index: true, foreign_key: true
  end
end
