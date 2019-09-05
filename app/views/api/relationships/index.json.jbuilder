json.key_format! camelize: :lower

json.followed @found_followed do |relationship|
  followed = relationship.followed
  json.id followed.id
  json.first_name followed.first_name
  json.last_name followed.last_name
  json.slug followed.slug
  json.profile_img followed.profile_img
end

json.followers @found_followers do |relationship|
  follower = relationship.follower
  json.id follower.id
  json.first_name follower.first_name
  json.last_name follower.last_name
  json.slug follower.slug
  json.profile_img follower.profile_img
end
