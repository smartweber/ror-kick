json.key_format! camelize: :lower

if @errors.present?
  json.errors @errors
  json.response do
    json.code 422
  end
else
  hosts = []

  json.attendees @attendees do |a|
    json.relation a.relation
    json.status a.status
    json.id a.id
    json.first_name a.first_name
    json.last_name a.last_name
    json.slug a.slug
    json.profile_img a.profile_img_url
    json.fb_id a.uid

    if @followed.present?
      for followed in @followed
        if followed.followed_id == a.id
          json.followed true
        end
      end
    end

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
    json.id h.uid

    (host = (@current_user && @current_user.id == h.id)) unless host
  end

  json.host host

  json.response do
    json.code 201
  end
end
