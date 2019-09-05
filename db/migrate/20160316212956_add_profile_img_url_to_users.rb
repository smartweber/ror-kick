class AddProfileImgUrlToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_img_url, :string
  end
end
