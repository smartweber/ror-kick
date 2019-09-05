class ChangeEventsTitleToName < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :title, :name
  end
end
