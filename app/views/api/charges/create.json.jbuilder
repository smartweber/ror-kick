if @errors.present?
  json.errors @errors.messages
  json.response do
    json.code 422
  end
else
  json.data do
    json.charge @charge
  end
  json.response do
    json.code 201
  end
end
