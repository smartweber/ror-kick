class ChangeEventsContributionDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :contribution,  :decimal, :precision => 8, :scale => 2
  end
end
