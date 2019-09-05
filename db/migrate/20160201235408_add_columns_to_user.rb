class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :stripe_customer_id, :string
    add_column :users, :profile_img, :string
    add_column :users, :profile_name, :string
  end
end
