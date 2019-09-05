class RemoveHeaderImgFromEvent < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :header_img, :string
  end
end
