class ChangeUserCreatedBy < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :user_id, :created_by
  end
end
