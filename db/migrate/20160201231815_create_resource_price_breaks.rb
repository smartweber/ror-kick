class CreateResourcePriceBreaks < ActiveRecord::Migration[5.0]
  def change
    create_table :resource_price_breaks do |t|
      t.integer :break_level, :default => 0, null: false
      t.decimal :price_per_unit, :precision => 8, :scale => 2, :default => 0.00, null: false
      t.references :resource, index: true, foreign_key: true

      t.timestamps
    end
  end
end
