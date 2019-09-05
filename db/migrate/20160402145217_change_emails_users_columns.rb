class ChangeEmailsUsersColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :emails_users, :from
    remove_column :emails_users, :sent
    remove_column :emails_users, :read
    add_column :emails_users, :sent, :datetime, default: nil
    add_column :emails_users, :read, :datetime, default: nil
    remove_column :emails_users, :body
    remove_column :emails_users, :to
    remove_column :emails_users, :to_name
    remove_column :emails_users, :created_by
    remove_column :emails_users, :event_id
    remove_column :emails_users, :subject
    remove_column :emails_users, :updated_at
  end
end
