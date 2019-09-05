class MakeUserUidUnique < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :uid
    add_index :users, :uid, unique: true
  end
end
