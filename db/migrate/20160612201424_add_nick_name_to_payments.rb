class AddNickNameToPayments < ActiveRecord::Migration[5.0]
  def change
  	add_column :payments, :nick_name, :string
  end
end
