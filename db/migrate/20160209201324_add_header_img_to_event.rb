class AddHeaderImgToEvent < ActiveRecord::Migration[5.0]
  def self.up
    add_attachment :events, :header_img
  end

  def self.down
    remove_attachment :events, :header_img
  end
end
