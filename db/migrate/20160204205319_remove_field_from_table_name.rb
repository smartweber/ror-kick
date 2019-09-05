class RemoveFieldFromTableName < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :contribution, :decimal
    remove_column :events, :contribution_note, :string
  end
end
