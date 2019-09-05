if @count
  json.response do
    json.code 200
  end
  json.count @count
else
  json.response do
      json.code 422
  end
end
