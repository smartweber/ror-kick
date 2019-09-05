if @user.present?
  json.response do
    json.code 200
  end
  json.data do
    json.email @user.email
    json.auth_token @auth_token
    json.id @user.id
  end
else
  json.errors do
    json.error 'Reset code not valid'
  end
  json.response do
    json.code 404
  end
end
