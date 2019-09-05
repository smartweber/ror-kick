json.key_format! camelize: :lower

json.array! @data do |order_data|

  json.order_date order_data['order_date']
  json.user_count order_data['user_count']
  json.total_cost order_data['total_cost']

end
