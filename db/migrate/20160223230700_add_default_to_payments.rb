class AddDefaultToPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :default, :boolean, :default => true
  end
end
