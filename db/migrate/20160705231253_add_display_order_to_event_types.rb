class AddDisplayOrderToEventTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :event_types, :display_order, :integer

    EventType.find_each.with_index do |et, i|
      if et.name == "Other"
        et.display_order = 1000
      else
        et.display_order = i
      end

      et.save!
    end
  end
end
