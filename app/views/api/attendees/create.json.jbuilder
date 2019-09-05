# if @attendee.errors.present?
#   json.errors @attendee.errors.messages
#   json.response do
#     json.code 422
#   end
# else
  json.response do
    json.code 201
  end
# end
