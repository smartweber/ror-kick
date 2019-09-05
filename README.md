#KickParty API

## Getting Started

One time:

```sh
bundle install
brew install elasticsearch
```

Then start elasticsearch in another terminal:

```sh
elasticsearch
```

You will need to reindex for elasticsearch:

```sh
rails c
> Event.reindex
```

If you're using DATABASE_URL for `rails c`, see this: https://github.com/rails/rails/issues/19256, you might need to run `spring stop`.

Start API server: 

```
bin/rails server
```

To use Puma directly and use puma.rb config:

```
PORT=3001 DATABASE_URL=postgres://USERNAME:PASSWORD@ec2-54-83-0-187.compute-1.amazonaws.com:5432/d8sq3icammgc6g puma -C config/puma.rb`
```


## API Endpoints

**SSL Will Be Required for ALL Endpoints**

### Events
1.  List: **GET:** https://api.kickparty.com/api/events

2.  Get Single Event:
  * By Slug (always use in app): **GET:** https://api.kickparty.com/api/events/:slug

  * By ID (testing ONLY): **GET:** https://api.kickparty.com/api/events/:id

3.  Create: **POST:** https://api.kickparty.com/api/events

**POST BODY:**


    {
      "event": {
        "name": "My Sweet Event",
        "description": "It's gonna be nuts, yo!",
        "headerImg": "https://media4.giphy.com/media/IjjqQvfFpSSxG/200_s.gif",
        "profileImg": "https://media4.giphy.com/media/IjjqQvfFpSSxG/200_s.gif",
        "slug": "slug-for-event",
        "locationName" :"Event Location",
        "locationAddress" :"123 My St, Reno, NV",
        "contact_email": "me@me.com",
        "contact_phone": "212-333-3444",
        "start": "datetime",
        "end": "datetime",
        "deadline": "datetime",
        "min_attendee_count": "232",
        "event_type_id": "2"
      },
      "resources": [
        {
          name: 'New Resource',
          id: 10
          description: 'Lorem ipsum dolor sit amet',
          price: 1234.56,
          resource_type_id: 1,
          private: false
        },
        {
          // Another Resource
        }
      ]
    }


### Resources

1.  List:

  * All ResourceTypes: **GET:** https://api.kickparty.com/api/resources

  * By ResourceType: **GET:** https://api.kickparty.com/api/resources?resource_type_id=4

2.  Create:

  * With Tier_Resource: **POST:** https://api.kickparty.com/api/resources

**POST BODY:**

    {
      "resource": {
        "name": "Big ass boat",
        "description": "I'm the king of the world on a boat like Leo...",
        "resourceTypeId": 3,
        "price": 999.45
      },
      "tier": {
        "tierId": 26,
        "price": 33
      }
    }


  * **Without** Tier_Resource: **POST:** https://api.kickparty.com/api/resources

*Only for use outside of event creation*

**BODY:**

    {
      "resource": {
        "name": "Big ass boat",
        "description": "I'm the king of the world on a boat like Leo...",
        "resourceTypeId": 3,
        "price": 999.45
      }
    }


### EventTypes

  1.  List: **GET:** https://api.kickparty.com/api/event_types

### ResourceTypes

  1.  List: **GET:** https://api.kickparty.com/api/resource_types

### Users

  *TODO*
