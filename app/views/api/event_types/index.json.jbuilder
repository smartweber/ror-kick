json.key_format! camelize: :lower

json.array! @event_types do |event_type|
  json.id event_type.id
  json.name event_type.name
end
