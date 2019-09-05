if @error_message
  json.errors @error_message
else
  json.data do
    json.email @current_user.email
    json.auth_token @auth_token
    json.id @current_user.id
    json.first_name @current_user.first_name
    json.last_name @current_user.last_name
    json.bio @current_user.bio
    json.payment @current_user.stripe_customer_id ? true : false
    json.profile_img @current_user.profile_img_url
    json.slug @current_user.slug
    json.fb_id @current_user.uid
  end
  json.response do
    json.code 201
  end
end
