# Posts

## Endpoints

### GET  `/posts/feed`
Gets feed of the logged in user.

- The `change_it` and `wear_it` button keys are absent if voting is disabled.

Following is a sample response for `/posts/feed?offset=3`. The example uses a limit of 3 but on produciton it's set to 20.

```json
{
  "feed": [
    {
      "id": 1423,
      "user": {
        "id": "6654D05",
        "name": "gtiotwit2 K.",
        "location": "Bk, NY",
        "icon": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/6cddd37ef45dc3c73d87dfb7b96de0c3_110_110.jpg",
        "badge": 
          {
              "default": "http://assets.gotryiton.com/img/badges/1/badge-flat-model.png",
              "profile": "http://assets.gotryiton.com/img/badges/1/badge-profile-model.png",
              "flat": "http://assets.gotryiton.com/img/badges/1/badge-flat-model.png",
              "outfit": "http://assets.gotryiton.com/img/badges/1/badge-outfit-model.png",
              "shaded": "http://assets.gotryiton.com/img/badges/1/badge-shaded-model.png",
              "small": "http://assets.gotryiton.com/img/badges/1/badge-review-model.png"
          }
        ,
        "action": "/users/6654D05",
        "follow_button": {
          "text": "following",
          "action": "/users/6654D05/unfollow",
          "state": 1
        }
      },
      "reviews": {
        "action": "/post/1423/reviews",
        "count": 0
      },
      "outfit": {
        "description": "afdasfdafa",
        "brands_description": "2222des",
        "main_image": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/187a1c600d9d3e9c537c3bd301eabc04.jpg",
        "square_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/187a1c600d9d3e9c537c3bd301eabc04_110_110.jpg",
        "small_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/187a1c600d9d3e9c537c3bd301eabc04_101_131.jpg"
      },
      "brands": [
      ],
      "heart": {
        "state": 0,
        "action": "/posts/1423/heart"
      },
      "hearts": {
        "count": 0,
        "action": "/posts/1423/hearts"
      },
      "users_who_hearted_this": [
      ],
      "vote": {
        "enabled": true,
        "count": 1,
        "verdict": true,
        "pending": true,
        "wear_it": {
          "count": 1,
          "state": 0,
          "action": "/post/1423/vote/wear-it"
        },
        "change_it": {
          "count": 0,
          "state": 0,
          "action": "/post/1423/vote/change-it"
        }
      },
      "created_at": 1334245987,
      "created_when": "4 weeks ago",
      "post_type": "outfit"
    },
    {
      "id": 1421,
      "user": {
        "id": "6654D05",
        "name": "gtiotwit2 K.",
        "location": "Bk, NY",
        "icon": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/6cddd37ef45dc3c73d87dfb7b96de0c3_110_110.jpg",
        "badge": null,
        "action": "/users/6654D05",
        "follow_button": {
          "text": "following",
          "action": "/users/6654D05/unfollow",
          "state": 1
        }
      },
      "reviews": {
        "action": "/post/1421/reviews",
        "count": 2
      },
      "outfit": {
        "description": "Bababbaba",
        "brands_description": "",
        "main_image": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/91d9e0cb6124a70cfcacc7b759fdb5ef.jpg",
        "square_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/91d9e0cb6124a70cfcacc7b759fdb5ef_110_110.jpg",
        "small_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/91d9e0cb6124a70cfcacc7b759fdb5ef_101_131.jpg"
      },
      "brands": [
      ],
      "heart": {
        "state": "0",
        "action": "/posts/1421/heart"
      },
      "hearts": {
        "count": "0",
        "action": "/posts/1421/hearts"
      },
      "users_who_hearted_this": [
      ],
      "vote": {
        "enabled": true,
        "count": 1,
        "verdict": true,
        "pending": true,
        "wear_it": {
          "count": 1,
          "state": 0,
          "action": "/post/1421/vote/wear-it"
        },
        "change_it": {
          "count": 0,
          "state": 0,
          "action": "/post/1421/vote/change-it"
        }
      },
      "created_at": 1334180149,
      "created_when": "4 weeks ago",
      "post_type": "outfit"
    },
    {
      "id": 1417,
      "user": {
        "id": "42BDB51",
        "name": "Ashish",
        "location": "Manhattan, New York",
        "icon": "http://graph.facebook.com/538638807/picture",
        "badges": [
        ],
        "action": "/users/42BDB51",
        "following_button": {
          "text": "following",
          "action": "/users/42BDB51/unfollow",
          "state": 1
        }
      },
      "reviews": {
        "action": "/post/1417/reviews",
        "count": 0
      },
      "outfit": {
        "description": "Blue?",
        "brands_description": "",
        "main_image": "http://stage.assets.gotryiton.s3.amazonaws.com/img/removed/removed_420_560.png",
        "square_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/img/removed/removed_110_110.png",
        "small_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/img/removed/removed_101_131.png"
      },
      "brands": [
      ],
      "heart": {
        "state": 0,
        "action": "/posts/1417/heart"
      },
      "hearts": {
        "count": 0,
        "action": "/posts/1417/hearts"
      },
      "users_who_hearted_this": [
      ],
      "vote": {
        "enabled": true,
        "count": 25,
        "verdict": "wear it",
        "pending": false,
        "weart_it": {
          "count": 23,
          "state": 0,
          "action": "/post/1417/vote/wear-it"
        },
        "change_it": {
          "count": 2,
          "state": 0,
          "action": "/post/1417/vote/change-it"
        }
      },
      "created_at": 1333724425,
      "created_when": "a month ago",
      "post_type": "outfit"
    }
  ],
  "pagination": {
    "previous_page": "/posts/feed?offset=0",
    "next_page": "/posts/feed?offset=6"
  }
}
```

### POST  `/post/create`
Creates and returns a post object based on passed parameters.

- **Must provide:** `description` `(string)` and `voting_enabled` `(boolean)`.
- **Must provide either one:** `photo_id` `(string)` or `product_id` `(int)` . If both are provided then `photo_id` takes precedence.

#### Request
```json
{
  "description": "This is a post.",
  "voting_enabled": true,
  "photo_id": "76199FA"
}
```

#### Response
```json
{
  "post": {
    "id": "1430",
    "user": {
      "id": "42BDB51",
      "name": "Ashish",
      "location": "Manhattan, New York",
      "icon": "http://graph.facebook.com/538638807/picture",
      "action": "/user/42BDB51/profile",
      "follow_button": null
    },
    "reviews": {
      "action": "/post/1430/reviews",
      "count": 0
    },
    "outfit": {
      "description": "This is a post.",
      "brands_description": null,
      "main_image": null,
      "square_thumbnail": null,
      "small_thumbnail": null
    },
    "brands": [
    ],
    "heart": {
      "state": 0,
      "action": "/posts/1430/heart"
    },
    "hearts": {
      "count": 0,
      "action": "/posts/1430/hearts"
    },
    "users_who_hearted_this": null,
    "vote": {
      "enabled": false,
      "count": 0,
    },
    "created_at": 1337012650,
    "created_when": "just now",
    "post_type": "outfit"
  }
}
```

### POST  `/posts/by-user(/:id)`
Responds with posts created by the user that is logged in if no `id` is passed. Responds with errors if the logged in user is not authorized to access the requested user's posts or if the passed `id` doesn't map to an existing user.

Following is a response to `/posts/by-user?offset=3`. The example uses a limit of 3 but on produciton it's set to 20.

```json
{
  "posts": [
    {
      "id": 610,
      "user": {
        "id": "02022CB",
        "name": "simonmm H.",
        "location": "Boston, MA",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/02022CB/profile",
        "follow_button": {
          "text": "follow",
          "action": "/user/02022CB/follow",
          "state": 0
        }
      },
      "reviews": {
        "action": "/post/610/reviews",
        "count": 1
      },
      "outfit": {
        "description": "penguins and koala in for an interview at GTIO Boston ",
        "brands_description": "penguin feathers ",
        "main_image": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/CCE537F.jpg",
        "square_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/CCE537F_110_110.jpg",
        "small_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/CCE537F_101_131.jpg"
      },
      "brands": [
      ],
      "heart": {
        "state": "0",
        "action": "/posts/610/heart"
      },
      "hearts": {
        "count": "0",
        "action": "/posts/610/hearts"
      },
      "users_who_hearted_this": [
      ],
      "vote": {
        "enabled": true,
        "count_votes": 11,
        "verdict": false,
        "pending": false,
        "wear_it": {
          "count": 11,
          "state": 0,
          "action": "/post/610/vote/wear-it"
        },
        "change_it": {
          "count": 0,
          "state": 0,
          "action": "/post/610/vote/change-it"
        }
      },
      "created_at": 1278603818,
      "created_when": "2 years ago",
      "post_type": "outfit"
    },
    {
      "id": 14,
      "user": {
        "id": "02022CB",
        "name": "simonmm H.",
        "location": "Boston, MA",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/02022CB/profile",
        "follow_button": {
          "text": "follow",
          "action": "/user/02022CB/follow",
          "state": 0
        }
      },
      "reviews": {
        "action": "/post/14/reviews",
        "count": 0
      },
      "outfit": {
        "description": "aa ",
        "brands_description": "",
        "main_image": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/57A7142.jpg",
        "square_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/57A7142_110_110.jpg",
        "small_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/57A7142_101_131.jpg"
      },
      "brands": [
        {
          "id": "american_apparel",
          "name": "American Apparel"
        }
      ],
      "heart": {
        "state": "0",
        "action": "/posts/14/heart"
      },
      "hearts": {
        "count": "0",
        "action": "/posts/14/hearts"
      },
      "users_who_hearted_this": [
      ],
      "vote": {
        "enabled": true,
        "count_votes": 6,
        "verdict": true,
        "pending": true,
        "wear_it": {
          "count": 6,
          "state": 0,
          "action": "/post/14/vote/wear-it"
        },
        "change_it": {
          "count": 0,
          "state": 0,
          "action": "/post/14/vote/change-it"
        }
      },
      "created_at": 1278602393,
      "created_when": "2 years ago",
      "post_type": "outfit"
    },
    {
      "id": 188,
      "user": {
        "id": "02022CB",
        "name": "simonmm H.",
        "location": "Boston, MA",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/02022CB/profile",
        "follow_button": {
          "text": "follow",
          "action": "/user/02022CB/follow",
          "state": 0
        }
      },
      "reviews": {
        "action": "/post/188/reviews",
        "count": 2
      },
      "outfit": {
        "description": "penguins interviewing jelly fish ",
        "brands_description": "",
        "main_image": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/BF20445.jpg",
        "square_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/BF20445_110_110.jpg",
        "small_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/BF20445_101_131.jpg"
      },
      "brands": [
      ],
      "heart": {
        "state": "0",
        "action": "/posts/188/heart"
      },
      "hearts": {
        "count": "0",
        "action": "/posts/188/hearts"
      },
      "users_who_hearted_this": [
      ],
      "vote": {
        "enabled": true,
        "count_votes": 1,
        "verdict": true,
        "pending": true,
        "wear_it": {
          "count": 1,
          "state": 0,
          "action": "/post/188/vote/wear-it"
        },
        "change_it": {
          "count": 0,
          "state": 0,
          "action": "/post/188/vote/change-it"
        }
      },
      "created_at": 1278602295,
      "created_when": "2 years ago",
      "post_type": "outfit"
    }
  ],
  "pagination": {
    "previous_page": "/posts/by-user/02022CB?offset=0",
    "next_page": "/posts/by-user/02022CB?offset=6"
  }
}
```