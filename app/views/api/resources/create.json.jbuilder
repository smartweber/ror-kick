if @resource.errors.present?
  json.errors @resource.errors.messages
  json.response do
    json.code 422
  end
else
  json.data do
    json.id @resource.id
    json.name @resource.name
    json.description @resource.description

    if @tier_resource
      json.tier_resource_id @tier_resource.id
      json.price @tier_resource.price
    else
      json.price @resource.price
    end
  end
  json.response do
    json.code 201
  end
end
