class AddProfileImgToUsers < ActiveRecord::Migration[5.0]
  def self.up
    add_attachment :users, :profile_img
  end

  def self.down
    remove_attachment :users, :profile_img
  end
end
