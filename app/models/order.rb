class Order < ApplicationRecord
  has_many :order_items
  belongs_to :events_user
  belongs_to :payment

  def order_total
    order_items.sum(:cost)
  end

  def order_event
    events_user.event
  end

  def order_user
    events_user.user
  end
end
