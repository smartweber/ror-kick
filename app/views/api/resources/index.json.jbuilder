json.key_format! camelize: :lower

json.array! @resources do |resource|
  json.id resource.id
  json.name resource.name
  json.description resource.description
  json.price resource.price
  json.private resource.private
end
