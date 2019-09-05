# if @customer.errors.present?
#   json.errors @customer.errors.messages
#   json.response do
#     json.code 422
#   end
# else
  json.data do
    json.success true
  end
  json.response do
    json.code 201
  end
# end
