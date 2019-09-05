if @errors
  json.errors @errors
else
  json.message @message
end

# if json.data.errors.present?
#   # json.errors json.data.errors.messages
#   json.response do
#     json.code 422
#   end
# else
#   json.data do
#     json.loggedOut json.data.logged_out
#   end
#   json.response do
#     json.code 201
#   end
# end
