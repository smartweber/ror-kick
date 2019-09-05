if @post.errors.present?
  json.errors @post.errors.messages
  json.response do
    json.code 422
  end
else
  json.data do
    json.title @post.title
    json.body @post.body
    json.id @post.id
    json.created_at @post.created_at
    json.like_count 0
    json.like false
    json.pinned @post.pinned
    json.me true
    json.event_id @post.event_id
    json.user do
      json.first_name @current_user.first_name
      json.last_name @current_user.last_name
      json.slug @current_user.slug
      json.profile_img @current_user.profile_img_url
      json.fb_id @current_user.uid
    end
  end
  json.response do
    json.code 201
  end
end
