class AddPublishedToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :published, :boolean, default: false
  end
end
