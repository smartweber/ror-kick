class AddContributionNoteToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :contribution_note, :string
  end
end
