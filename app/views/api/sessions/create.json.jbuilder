if @errors
  json.errors @errors
else
  json.data do
    json.email @user.email
    json.auth_token @auth_token
    json.payment @user.stripe_customer_id ? true : false
    json.first_name @user.first_name
    json.last_name @user.last_name
    json.profile_img @user.profile_img_url
    json.slug @user.slug
    json.fb_id @user.uid
  end
  json.response do
    json.code 200
  end
end
