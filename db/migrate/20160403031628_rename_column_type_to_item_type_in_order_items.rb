class RenameColumnTypeToItemTypeInOrderItems < ActiveRecord::Migration[5.0]
  def change
    rename_column :order_items, :type, :item_type
  end
end
