class AddKeyToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :key, :string
  end
end
