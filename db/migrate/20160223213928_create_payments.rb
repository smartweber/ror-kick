class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.string :stripe_customer_id
      t.integer :payment_type, :default => 4 # visa
      t.string :number, :limit => 4
      t.integer :exp_month
      t.integer :exp_year
      t.string :address_line1
      t.string :address_zip
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
