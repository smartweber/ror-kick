class CreateFbFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :fb_friends do |t|
      t.string :user_uid, null: false
      t.string :friend_uid, null: false
      t.timestamps
    end

    add_foreign_key :fb_friends, :users, column: :user_uid, primary_key: :uid
    add_foreign_key :fb_friends, :users, column: :friend_uid, primary_key: :uid
  end
end
