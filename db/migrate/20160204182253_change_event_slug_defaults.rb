class ChangeEventSlugDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :slug, :string, unique: true
  end

end
