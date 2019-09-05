# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ObjectType.create(id: 1, name: 'Post')
ObjectType.create(id: 2, name: 'Comment')

ResourceType.create(id: 0, name: 'Default')
ResourceType.create(name: 'Photographer')
ResourceType.create(name: 'Bartender')
ResourceType.create(name: 'Band')
ResourceType.create(name: 'Catering')
ResourceType.create(name: 'Venue')
ResourceType.create(name: 'Limo/Bus')
ResourceType.create(name: 'Boat')
ResourceType.create(name: 'Default')

EventType.create(id: 0, name: 'Default')
EventType.create(name: 'Other')
EventType.create(name: 'Wedding')
EventType.create(name: 'Concert')
EventType.create(name: 'Bachelorette Party')
EventType.create(name: 'Bachelor Party')
EventType.create(name: 'Reunion')
EventType.create(name: 'Engagement Party')
EventType.create(name: 'Birthday Party')
EventType.create(name: 'Holiday Party')

Resource.create(id: 0, name: 'Default', description: 'Default',
  price: 0, private: true, resource_type_id: 0)
Resource.create(name: 'Jane Doe', description: 'Photographer for hire',
  price: 500, private: false, resource_type_id: 1)
Resource.create(name: 'John Doe', description: 'Bartender for hire',
  price: 250, private: false, resource_type_id: 2)
Resource.create(name: 'Mouse Rat', description: 'Band for hire',
  price: 300, private: false, resource_type_id: 3)
Resource.create(name: 'Jimmy Johns', description: 'Catering',
  price: 300, private: false, resource_type_id: 4)

User.create(email: 'ww@gmail.com', password: 'password',
  first_name: 'Walter', last_name: 'White', slug: 'Walter')
User.create(email: 'jp@gmail.com', password: 'password',
  first_name: 'Jesse', last_name: 'Pinkman', slug: 'Jesse')
User.create(email: 'ds@gmail.com', password: 'password',
  first_name: 'Dana', last_name: 'Scully', slug: 'Scully')

Event.create(created_by: 1, key: '0000000001',
  name: 'Walter\'s Birthday', description: 'Insert description here.',
  location_name: 'Incline Village', location_address: 'Incline Village, NV 89451, USA',
  contact_email: 'ww@gmail.com', contact_phone: '775-111-1111',
  event_type_id: 8,
  deadline: "2020-02-20T20:00:00.000Z",
  start: "2020-02-20T20:00:00.000Z",
  end: "2020-02-28T20:00:00.000Z")
Event.create(created_by: 1, key: '0000000002',
  name: 'Walter\'s Reunion', description: 'Insert description here.',
  location_name: 'Incline Village', location_address: 'Incline Village, NV 89451, USA',
  contact_email: 'ww@gmail.com', contact_phone: '775-111-1111',
  event_type_id: 6,
  deadline: "2020-02-20T20:00:00.000Z",
  start: "2020-02-20T20:00:00.000Z",
  end: "2020-02-28T20:00:00.000Z")
Event.create(created_by: 2, key: '0000000003',
  name: 'Jesse\'s Bachelor Party', description: 'Insert description here.',
  location_name: 'Albuquerque', location_address: 'Albuquerque, NM 87102, USA',
  contact_email: 'jp@gmail.com', contact_phone: '505-148-3369',
  event_type_id: 5,
  deadline: "2020-02-20T20:00:00.000Z",
  start: "2020-02-20T20:00:00.000Z",
  end: "2020-02-28T20:00:00.000Z")
Event.create(created_by: 2, key: '0000000004',
  name: 'Jesse\'s Engagement Party', description: 'Insert description here.',
  location_name: 'Albuquerque', location_address: 'Albuquerque, NM 87102, USA',
  contact_email: 'jp@gmail.com', contact_phone: '505-148-3369',
  event_type_id: 7,
  deadline: "2020-02-20T20:00:00.000Z",
  start: "2020-02-20T20:00:00.000Z",
  end: "2020-02-28T20:00:00.000Z")
Event.create(created_by: 3, key: '0000000005',
  name: 'Scully\'s Holiday Party', description: 'Insert description here.',
  location_name: 'FBI Headquarters', location_address: 'Washington, DC 20535, USA',
  contact_email: 'ds@gmail.com', contact_phone: '202-278-2000',
  event_type_id: 9,
  deadline: "2020-02-20T20:00:00.000Z",
  start: "2020-02-20T20:00:00.000Z",
  end: "2020-02-28T20:00:00.000Z")
Event.create(created_by: 3, key: '0000000006',
  name: 'Scully\'s Reunion', description: 'Insert description here.',
  location_name: 'FBI Headquarters', location_address: 'Washington, DC 20535, USA',
  contact_email: 'ds@gmail.com', contact_phone: '202-278-2000',
  event_type_id: 6,
  deadline: "2020-02-20T20:00:00.000Z",
  start: "2020-02-20T20:00:00.000Z",
  end: "2020-02-28T20:00:00.000Z")

EventsUser.create(event_id: 1, user_id: 1)
EventsUser.create(event_id: 2, user_id: 1)

Tier.create(event_id: 1, min_attendee_count: 10, max_attendee_count: 50,
  contribution: 0, contribution_note: 'I contributed $0.', base_cost: 10)
Tier.create(event_id: 2, min_attendee_count: 10, max_attendee_count: 60,
  contribution: 100, contribution_note: 'I contributed $100.', base_cost: 5000)
Tier.create(event_id: 3, min_attendee_count: 10, max_attendee_count: 70,
  contribution: 500, contribution_note: 'I contributed $500.', base_cost: 2000)
Tier.create(event_id: 4, min_attendee_count: 10, max_attendee_count: 80,
  contribution: 2000, contribution_note: 'I contributed $2000.', base_cost: 4000)
Tier.create(event_id: 5, min_attendee_count: 10, max_attendee_count: 90,
  contribution: 300, contribution_note: 'I contributed $300.', base_cost: 1200)
Tier.create(event_id: 6, min_attendee_count: 10, max_attendee_count: 100,
  contribution: 200, contribution_note: 'I contributed $200.', base_cost: 1000)

TierResource.create(tier_id: 1, resource_id: 0)
TierResource.create(tier_id: 1, resource_id: 1, price: 500)
TierResource.create(tier_id: 1, resource_id: 2, price: 250)
TierResource.create(tier_id: 1, resource_id: 3, price: 300)
TierResource.create(tier_id: 1, resource_id: 4, price: 300)
TierResource.create(tier_id: 2, resource_id: 0)
TierResource.create(tier_id: 2, resource_id: 1, price: 500)
TierResource.create(tier_id: 2, resource_id: 2, price: 250)
TierResource.create(tier_id: 2, resource_id: 3, price: 300)
TierResource.create(tier_id: 2, resource_id: 4, price: 300)
TierResource.create(tier_id: 3, resource_id: 0)
TierResource.create(tier_id: 3, resource_id: 1, price: 500)
TierResource.create(tier_id: 3, resource_id: 2, price: 250)
TierResource.create(tier_id: 3, resource_id: 3, price: 300)
TierResource.create(tier_id: 3, resource_id: 4, price: 300)
TierResource.create(tier_id: 4, resource_id: 0)
TierResource.create(tier_id: 4, resource_id: 1, price: 500)
TierResource.create(tier_id: 4, resource_id: 2, price: 250)
TierResource.create(tier_id: 4, resource_id: 3, price: 300)
TierResource.create(tier_id: 4, resource_id: 4, price: 300)
TierResource.create(tier_id: 5, resource_id: 0)
TierResource.create(tier_id: 5, resource_id: 1, price: 500)
TierResource.create(tier_id: 5, resource_id: 2, price: 250)
TierResource.create(tier_id: 5, resource_id: 3, price: 300)
TierResource.create(tier_id: 5, resource_id: 4, price: 300)
TierResource.create(tier_id: 6, resource_id: 0)
TierResource.create(tier_id: 6, resource_id: 1, price: 500)
TierResource.create(tier_id: 6, resource_id: 2, price: 250)
TierResource.create(tier_id: 6, resource_id: 3, price: 300)
TierResource.create(tier_id: 6, resource_id: 4, price: 300)
