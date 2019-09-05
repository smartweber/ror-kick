json.slug @event.slug
json.short_url_link @event.short_url_link
json.header_img_file_name @event.header_img_file_name
json.key @event.key

json.tiers_attributes @event.tiers do |tier|
  json.id tier.id

  json.resources_attributes tier.resources do |tier_resource|
    json.id tier_resource.id
  end
end
