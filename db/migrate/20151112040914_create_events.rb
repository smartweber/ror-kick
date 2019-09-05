class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.string :profile_img
      t.string :header_img

      t.timestamps null: false
    end
  end
end
