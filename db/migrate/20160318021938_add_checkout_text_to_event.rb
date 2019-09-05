class AddCheckoutTextToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :checkout_text, :string
  end
end
