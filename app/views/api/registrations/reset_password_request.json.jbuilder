if !@user.present?
  json.errors do
    json.error 'Email not found'
  end
  json.response do
    json.code 404
  end
elsif @user.errors.present?
  json.errors @user.errors.messages
  json.response do
    json.code 422
  end
elsif @user.present?
  json.response do
    json.code 200
  end
  json.data do
    json.email @user.email
  end
end
