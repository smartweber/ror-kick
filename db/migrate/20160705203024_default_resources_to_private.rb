class DefaultResourcesToPrivate < ActiveRecord::Migration[5.0]
  def change
    change_column :resources, :private, :boolean, default: true
  end
end
