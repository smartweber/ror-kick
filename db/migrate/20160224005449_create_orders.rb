class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :status
      t.references :events_user, foreign_key: true
      t.references :payment, foreign_key: true
      t.string :stripe_customer_id

      t.timestamps
    end
  end
end
