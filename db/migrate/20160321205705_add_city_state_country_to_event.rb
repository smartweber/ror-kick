class AddCityStateCountryToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :location_city, :string, :null => true
    add_column :events, :location_state, :string, :null => true
    add_column :events, :location_country, :string, :null => true
  end
end
