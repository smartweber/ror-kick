# Endpoints
- [Attendees](#Attendees)
- [Charges](#Charges)
- [Comments](#Comments)
- [Customers](#Customers)
- [Emails](#Emails)
- [EventTypes](#EventTypes)
- [Events](#Events)
- [Likes](#Likes)
- [Orders](#Orders)
- [Payments](#Payments)
- [Posts](#Posts)
- [Registrations](#Registrations)
- [Relationships](#Relationships)
- [ResourceTypes](#ResourceTypes)
- [Resources](#Resources)
- [Sessions](#Sessions)
- [Users](#Users)

<a id="Attendees"></a>
## Attendees
- GET `/api/events/:id/attendees` &rarr; attendees#index

  Return attendees going to an event

- POST `/api/attendees` &rarr; attendees#create

  Add attendees going to an event

- POST `/api/attendees/attend` &rarr; attendees#attend

  Unknown

- DELETE `/api/events/:id/attendees` &rarr; attendees#destroy

  Remove an attendee to an event

<a id="Charges"></a>
## Charges
- POST `/api/charges` &rarr; charges#create

  Create a new charge and emails the order-maker

- POST `/api/charges/failed/:id` &rarr; charges#failed

  Remove an order and emails the order-maker

<a id="Comments"></a>
## Comments
- POST `/api/comments` &rarr; comments#create

  Add a comment to an event

- DELETE `/api/comments/:id` &rarr; comments#destroy

  Remove a comment

<a id="Customers"></a>
## Customers
- POST `/api/customers` &rarr; customers#create

  Create a customer (being deprecated)

<a id="Emails"></a>
## Emails
- POST `/api/emails` &rarr; emails#create

  Send emails to a group

- GET `images/:id/kickparty-email.png` &rarr; emails#mark_read

  Mark an email as read

<a id="EventTypes"></a>
## EventTypes
- GET `/api/event_types` &rarr; event_types#index

  Return the known event types

<a id="Events"></a>
## Events
- GET `/api/events` &rarr; events#index

  Return all events

- POST `/api/events` &rarr; events#create

  Create a new event

- GET `/api/events/:id` &rarr; events#show

  Return the details of an event

- DELETE `/api/events/:id` &rarr; events#destroy

  Removes an event

- POST `/api/events/:id/update` &rarr; events#update

  Edit information about an event

- POST `/api/events/search` &rarr; events#search

  Search for an event (with ElasticSearch)

- GET `/events/cal/:id` &rarr; events#calendar

  Unknown

<a id="Likes"></a>
## Likes
- GET `/api/likes` &rarr; likes#index

  Return likes on a post or comment

- POST `/api/likes` &rarr; likes#create

  Create a new like on a post or comment

- DELETE `/api/likes/:id` &rarr; likes#destroy

  Remove a like

<a id="Orders"></a>
## Orders
- GET `/api/orders` &rarr; orders#index

  Unimplemented

- POST `/api/orders` &rarr; orders#create

  Unimplemented

- GET `/api/orders/:id` &rarr; orders#show

  Unimplemented

<a id="Payments"></a>
## Payments
- GET `/api/payments` &rarr; payments#index

  Return payment options

- POST `/api/payments` &rarr; payments#create

  Create a new payment option

- GET `/api/payments/:id` &rarr; payments#show

  Return payment option details

- POST `/api/payments/:id` &rarr; payments#destroy

  Remove a payment option

- GET `/api/payments/default` &rarr; payments#default

  Return the default payment option

- POST `/api/payments/default/:id` &rarr; payments#update_default

  Change the default payment option

<a id="Posts"></a>
## Posts
- GET `/api/posts` &rarr; posts#index

  Unused

- GET `/api/posts/:id` &rarr; posts#index

  Return the post

- POST `/api/posts` &rarr; posts#create

  Create a new post

<a id="Registrations"></a>
## Registrations
- POST `/api/users` &rarr; registrations#create

  Create a new user with the default system

- PATCH `/api/users` &rarr; registrations#update

  Unused, unimplemented, and should probably be removed

- PUT `/api/users` &rarr; registrations#update

  Unused, unimplemented, and should probably be removed

- DELETE `/api/users` &rarr; registrations#destroy

  Unused, unimplemented, and should probably be removed

- GET `/api/users/cancel` &rarr; registrations#cancel

  Unused, unimplemented, and should probably be removed

- GET `/api/users/sign_up` &rarr; registrations#new

  Unused, unimplemented, and should probably be removed

- GET `/api/users/edit` &rarr; registrations#edit

  Unused, unimplemented, and should probably be removed

- POST `/api/reset_password_request` &rarr; registrations#reset_password_request

  Request that a user's password be reset

- POST `/api/reset_password` &rarr; registrations#reset_password

  Attempt to reset a user's password

- POST `/api/facebook_login` &rarr; registrations#facebook_login

  Sign up and login via FaceBook

<a id="Relationships"></a>
## Relationships
- GET `/api/relationships` &rarr; relationships#index

  Return all following and followers

- POST `/api/relationships` &rarr; relationships#create

  Create a following relationship

- DELETE `/api/relationships` &rarr; relationships#destroy

  Remove a following relationship

<a id="ResourceTypes"></a>
## ResourceTypes
- GET `/api/resource_types` &rarr; resource_types#index

  Return all known resource types

- POST `/api/resource_types` &rarr; resource_types#create

  Create a new resource type

<a id="Resources"></a>
## Resources
- GET `/api/resources` &rarr; resources#index

  Return a specific resource

- POST `/api/resources` &rarr; resources#create

  Create a new resource

- DELETE `/api/resources` &rarr; resources#destroy

  Remove a resource

<a id="Sessions"></a>
## Sessions
- GET `/api/users/sign_in` &rarr; sessions#new

  Unused, unimplemented, and should probably be removed

- POST `/api/users/sign_in` &rarr; sessons#create

  Create a new session by logging in

- DELETE `/api/users/sign_out` &rarr; sessions#destroy

  Delete a session

- GET `/api/users/current_session` &rarr; sessions#current_session

  Return information about the current session

<a id="Users"></a>
## Users
- PATCH `/api/users/:id` &rarr; users#patch

  Update details about a user

- GET `/api/users/check_slug/:slug` &rarr; users#check_slug

  Check if username is taken

- POST `/api/users/check_email` &rarr; users#check_email

  Check if email is taken

- POST `/api/users/update_fb_friends` &rarr; users#update_fb_friends

  Update known FaceBook friends that use KickParty

- GET `/api/users/:id` &rarr; users#show

  Return information about the user
