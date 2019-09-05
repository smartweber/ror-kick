class AddEventIdPinnedToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :pinned, :boolean, default: false
    add_reference :posts, :event, index: true, foreign_key: true
  end
end
