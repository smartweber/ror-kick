class EventsUser < ApplicationRecord
  belongs_to :event
  belongs_to :user
  has_one :order

  def self.users_orders(event_id)
    users_orders = EventsUser
     .select('events_users.user_id, o.*, SUM(oi.cost) as order_sum')
     .joins('INNER JOIN orders AS o ON o.events_user_id = events_users.id')
     .joins('INNER JOIN order_items AS oi ON o.id = oi.order_id')
     .where('event_id = ?', event_id)
     .group('user_id', 'o.id')

    orders = {}
    users_orders.each do |order|
      orders[order.user.id.to_i] = order
    end
    orders
  end
end
