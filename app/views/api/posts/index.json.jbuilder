json.key_format! camelize: :lower

json.array! @posts do |post|
  json.title post.title
  json.body post.body
  json.id post.id
  json.created_at post.created_at
  json.like_count post.like_count
  json.comment_count post.comment_count
  json.like post.like
  json.user do
    json.first_name post.user_first_name
    json.last_name post.user_last_name
    json.slug post.user_slug
    json.profile_img post.user_profile_img_url
    json.fb_id post.user_uid
  end
  json.event_id post.event_id
  json.pinned post.pinned
  if post.user == @current_user
  		json.set! :me, true
  else
  		json.set! :me, false
  end

  json.comments post.comments do |comment|
    json.id comment.id
    json.like_count comment.like_count
    json.created_at comment.created_at
    json.liked comment.like_count > 0 && @current_user.present? ? comment.get_like_id(@current_user.id) : nil
    json.body comment.body
    json.user do
      json.first_name comment.user.first_name
      json.last_name comment.user.last_name
      json.slug comment.user.slug
      json.profile_img comment.user.profile_img_url
      json.fb_id comment.user.uid
    end
  end
end
