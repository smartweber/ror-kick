json.key_format! camelize: :lower

if @show_user.present?
  user = @show_user

  json.id user.id
  json.first_name user.first_name
  json.last_name user.last_name
  json.bio user.bio
  json.slug user.slug
  json.uid user.uid
  json.profile_img user.profile_img_url
  json.created_at user.created_at

  if (@current_user && user.id === @current_user.id)
    json.me true
    json.email user.email
    json.mobile_number user.mobile_number
  else
    json.me false
  end

  if @following != nil
    json.following @following
  end

  json.found_followers @found_followers do |relationship|
    follower = relationship.follower
    json.first_name follower.first_name
    json.last_name follower.last_name
    json.bio follower.bio
    json.slug follower.slug
    json.profile_img follower.profile_img
  end
  json.found_followed @found_followed do |relationship|
    followed = relationship.followed
    json.first_name followed.first_name
    json.last_name followed.last_name
    json.bio followed.bio
    json.slug followed.slug
    json.profile_img followed.profile_img
  end

  json.created_events @created_events do |event|
    json.id event.id
    json.name event.name
    json.description event.description
    json.id event.id
    json.slug event.slug
    json.profile_img event.profile_img
    json.header_img event.header_img(:square)
    json.location_name event.location_name
    json.location_address event.location_address
    json.location_lng event.location_lng
    json.location_lat event.location_lat
    json.start event.start
    json.end event.end
    json.deadline event.deadline
    json.event_type event.event_type.name
    json.user do
      json.first_name event.user.first_name
      json.last_name event.user.last_name
      json.slug event.user.slug
      json.profile_img event.user.profile_img_url
      json.fb_id event.user.uid
    end
  end

  json.attending_events @attending_events do |event|
    json.id event.id
    json.name event.name
    json.description event.description
    json.id event.id
    json.slug event.slug
    json.profile_img event.profile_img
    json.header_img event.header_img(:square)
    json.location_name event.location_name
    json.location_address event.location_address
    json.location_lng event.location_lng
    json.location_lat event.location_lat
    json.start event.start
    json.end event.end
    json.deadline event.deadline
    json.event_type event.event_type.name
    json.user do
      json.first_name event.user.first_name
      json.last_name event.user.last_name
      json.slug event.user.slug
      json.profile_img event.user.profile_img_url
      json.fb_id event.user.uid
    end
  end
  json.response do
    json.code 201
  end
else
  json.response do
    json.code 404
  end

end
