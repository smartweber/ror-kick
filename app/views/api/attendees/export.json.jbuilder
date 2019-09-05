json.key_format! camelize: :lower

if @errors.present?
  json.errors @errors
  json.response do
    json.code 422
  end
else

  json.attendees @attendees do |a|
    json.id a.id
    json.first_name a.first_name
    json.last_name a.last_name
    json.orders @orders[a.id] != nil ? @orders[a.id]['order_sum'] : nil
    json.processed @orders[a.id] != nil ? @orders[a.id]['processed'] : nil
    json.processed_date @orders[a.id] != nil ? @orders[a.id]['processed_at'] : nil
  end

  json.response do
    json.code 201
  end
end
