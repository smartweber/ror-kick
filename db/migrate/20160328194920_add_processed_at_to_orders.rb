class AddProcessedAtToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :processed_at, :datetime
  end
end
