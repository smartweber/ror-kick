class AddUserSetPriceToTiers < ActiveRecord::Migration[5.0]
  def change
    add_column :tiers, :user_set_price, :boolean, default: false
  end
end
