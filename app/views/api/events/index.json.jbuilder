json.key_format! camelize: :lower
json.array! @events do |event|
  json.id event.id
  json.name event.name
  json.description event.description
  json.id event.id
  json.slug event.slug
  json.profile_img event.profile_img
  json.header_img event.header_img(:square)
  json.location_name event.location_name
  json.location_address event.location_address
  json.location_city event.location_city
  json.location_state event.location_state
  json.location_country event.location_country
  json.start event.start
  json.end event.end
  json.deadline event.deadline
  json.timezone_offset event.timezone_offset
  json.timezone_name event.timezone_name
  # json.event_type event.event_type.name
  # json.user do
  #   json.first_name event.user.first_name
  #   json.last_name event.user.last_name
  #   json.slug event.user.slug
  #   json.profile_img event.user.profile_img_url
  #   json.fb_id event.user.uid
  # end
end
