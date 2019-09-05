json.key_format! camelize: :lower

if @comment.blank?
  json.response do
    json.code 422
  end
else
  json.data do
    json.body @comment.body
    json.id @comment.id
    json.object_type_id @comment.object_type_id
    json.object_id @comment.object_id
    json.like_count 0
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
