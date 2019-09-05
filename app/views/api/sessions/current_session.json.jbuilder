if @errors
  json.errors @errors
else
  json.data do
    json.email @current_user.email
    json.first_name @current_user.first_name
    json.last_name @current_user.last_name
    json.profile_img @current_user.profile_img_url
    json.slug @current_user.slug
    json.fb_id @current_user.uid
    json.payment @current_user.stripe_customer_id ? true : false
  end
  json.response do
    json.code 200
  end
end
