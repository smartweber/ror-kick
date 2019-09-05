if @like.blank?
  json.response do
    json.code 422
  end
else
  json.data do
    json.id @like.id
  end
  json.response do
    json.code 201
  end
end
