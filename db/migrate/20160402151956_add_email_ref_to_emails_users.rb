class AddEmailRefToEmailsUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :emails_users, :email, foreign_key: true
  end
end
