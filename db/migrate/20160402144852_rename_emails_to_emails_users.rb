class RenameEmailsToEmailsUsers < ActiveRecord::Migration[5.0]
  def change
    rename_table :emails, :emails_users
  end
end
