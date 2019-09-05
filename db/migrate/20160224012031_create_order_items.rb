class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.decimal :cost, :precision => 8, :scale => 2, :default => 0.00, null: false
      t.string :description
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
