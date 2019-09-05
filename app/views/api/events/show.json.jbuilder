json.key_format! camelize: :lower
attending = false

event = @event

json.id event.id
json.name event.name
json.description event.description
json.slug event.slug
json.short_url_link event.short_url_link
json.key event.key
json.status event.status
json.profile_img event.profile_img
json.header_img event.header_img
json.header_thumb_img event.header_img(:share_thumb)
json.location_name event.location_name
json.location_address event.location_address
json.location_lat event.location_lat
json.location_lng event.location_lng
json.location_city event.location_city
json.location_state event.location_state
json.location_country event.location_country
json.start event.start
json.end event.end
json.deadline event.deadline
json.timezone_offset event.timezone_offset
json.timezone_name event.timezone_name
json.contact_email event.contact_email
json.contact_phone event.contact_phone
json.event_type event.event_type.name
json.event_type_id event.event_type.id
json.kick_by event.kick_by
json.show_resources event.show_resources
json.show_dollars event.show_dollars
json.contributed @contributed
json.checkout_text event.checkout_text

json.user do
  json.first_name event.user.first_name
  json.last_name event.user.last_name
  json.slug event.user.slug
  json.profile_img event.user.profile_img_url
  json.fb_id event.user.uid
end

if @current_user && (@current_user.id == event.created_by)
  json.me true
  attending = true
else
  json.me false
end

# Match the create JSON structure
json.tiers_attributes event.tiers do |tier|
  json.id tier.id
  json.base_cost tier.base_cost
  json.calculation_method tier.calculation_method
  json.user_set_price tier.user_set_price
  json.cost_per_attendee tier.cost_per_attendee
  json.min_attendee_count tier.min_attendee_count
  json.max_attendee_count tier.max_attendee_count

  json.resources_attributes tier.resources do |tier_resource|
    json.id tier_resource.id
  end
end

json.tiers event.tiers do |tier|
  json.tier_id tier.id
  json.name tier.name
  json.description tier.description
  json.contribution tier.contribution
  json.contribution_note tier.contribution_note
  json.base_cost tier.base_cost
  json.calculation_method tier.calculation_method
  json.user_set_price tier.user_set_price
  json.cost_per_attendee tier.cost_per_attendee
  json.min_attendee_count tier.min_attendee_count
  json.max_attendee_count tier.max_attendee_count
  json.base_cost_per_attendee tier.base_cost_per_attendee
  json.total_cost_per_attendee tier.total_cost_per_attendee
  json.service_charge_per_attendee tier.service_charge_per_attendee
  json.tier_total_cost tier.tier_total_cost
  json.tier_total_resources tier.tier_total_resources
  json.kicked tier.kicked

  resource_map = {} # types -> []resources
  tier.tier_resources.includes(:resource).each do |tr|
    r = tr.resource
    rtype_resources = resource_map[r.resource_type_id]
    if !rtype_resources
      rtype = r.resource_type
      resource_map[r.resource_type_id] = {type: rtype, resources: [tr]}
    else
      rtype_resources[:resources] << tr
    end
    # p rtype_resources
  end

  json.resource_types resource_map do |k,v|
    rt = v[:type]

    if rt
      json.id rt.id
      json.name rt.name
    end

    json.resources v[:resources] do |tr|
      r = tr.resource
      json.tier_resource_id tr.id
      json.price tr.price

      json.resource_id r.id
      json.name r.name
      json.description r.description
      if rt
        json.resource_type_id rt.id
      end
      json.private r.private

    end
  end
end

attendees = User
            .select("users.id, users.first_name, users.last_name, users.slug, users.profile_img_url, users.uid, events_users.status, events_users.relation")
            .joins(:events)
            .where(["events.id = ?", event.id])
            .order("events_users.relation DESC, events_users.status, events_users.id DESC")

hosts = []

json.attendees attendees do |a|
  json.relation a.relation
  json.status a.status
  json.id a.id
  json.first_name a.first_name
  json.last_name a.last_name
  json.slug a.slug
  json.profile_img a.profile_img_url
  json.fb_id a.uid

  if @current_user
    if a.id == @current_user.id
        json.set! :me, true
        attending = true
    else
        json.set! :me, false
    end

  end

  if a.relation == 1
    hosts << a
  end

end

host = false

json.hosts hosts do |h|
  json.first_name h.first_name
  json.last_name h.last_name
  json.slug h.slug
  json.profile_img h.profile_img_url
  json.fb_id h.uid

  (host = (@current_user && @current_user.id == h.id)) unless host
end

json.host host

json.total_count event.total_count
json.committed_count event.committed_count
json.maybe_count event.maybe_count

json.attending attending
