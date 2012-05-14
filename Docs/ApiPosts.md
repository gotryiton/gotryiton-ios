# Posts

## Endpoints

### GET  `/posts/feed?offset=20`
Gets feed of the logged in user.

- Pages are numbered from 1 and it defaults to the first page if no page is specified.
- The `change_it` and `wear_it` button keys are absent if voting is disabled.

Following is a sample response for `/posts/feed.json?offset=3`. The example uses a limit of 3 but on produciton it's set to 20.

```json
{
  "feed": [
    {
      "id": 1423,
      "user": {
        "id": "6654D05",
        "name": "gtiotwit2 K.",
        "location": "Bk, NY",
        "user_icon": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/6cddd37ef45dc3c73d87dfb7b96de0c3_110_110.jpg",
        "badges": [
          {
            "id": 22,
            "badge_type": 1,
            "image_urls": {
              "default": "http://assets.gotryiton.com/img/badges/1/badge-flat-model.png",
              "profile": "http://assets.gotryiton.com/img/badges/1/badge-profile-model.png",
              "flat": "http://assets.gotryiton.com/img/badges/1/badge-flat-model.png",
              "outfit": "http://assets.gotryiton.com/img/badges/1/badge-outfit-model.png",
              "shaded": "http://assets.gotryiton.com/img/badges/1/badge-shaded-model.png",
              "small": "http://assets.gotryiton.com/img/badges/1/badge-review-model.png"
            },
            "created_at": 1327441478
          }
        ],
        "action": "/users/6654D05",
        "following_button": {
          "text": "following",
          "action": "/users/6654D05/unfollow",
          "state": 1
        }
      },
      "reviews": {
        "action": "/post/1423/reviews",
        "count": "0"
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
        "state": "0",
        "action": "/posts/1423/heart"
      },
      "hearts": {
        "count": "0",
        "action": "/posts/1423/hearts"
      },
      "users_who_hearted_this": [
      ],
      "vote": {
        "enabled": true,
        "count_votes": 1,
        "verdict": true,
        "pending": true,
        "weart_it": {
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
        "user_icon": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/6cddd37ef45dc3c73d87dfb7b96de0c3_110_110.jpg",
        "badges": [
          {
            "id": 22,
            "badge_type": 1,
            "image_urls": {
              "default": "http://assets.gotryiton.com/img/badges/1/badge-flat-model.png",
              "profile": "http://assets.gotryiton.com/img/badges/1/badge-profile-model.png",
              "flat": "http://assets.gotryiton.com/img/badges/1/badge-flat-model.png",
              "outfit": "http://assets.gotryiton.com/img/badges/1/badge-outfit-model.png",
              "shaded": "http://assets.gotryiton.com/img/badges/1/badge-shaded-model.png",
              "small": "http://assets.gotryiton.com/img/badges/1/badge-review-model.png"
            },
            "created_at": 1327441478
          }
        ],
        "action": "/users/6654D05",
        "following_button": {
          "text": "following",
          "action": "/users/6654D05/unfollow",
          "state": 1
        }
      },
      "reviews": {
        "action": "/post/1421/reviews",
        "count": "2"
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
        "count_votes": 1,
        "verdict": true,
        "pending": true,
        "weart_it": {
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
        "user_icon": "http://graph.facebook.com/538638807/picture",
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
        "count": "0"
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
        "state": "0",
        "action": "/posts/1417/heart"
      },
      "hearts": {
        "count": "0",
        "action": "/posts/1417/hearts"
      },
      "users_who_hearted_this": [
      ],
      "vote": {
        "enabled": true,
        "count_votes": 0,
        "verdict": true,
        "pending": true,
        "weart_it": {
          "count": 0,
          "state": 0,
          "action": "/post/1417/vote/wear-it"
        },
        "change_it": {
          "count": 0,
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

### GET  `/posts/create`
Creates and returns a post object based on passed parameters.

- **Must provide:** `description` `(string)` and `voting_enabled` `(boolean)`.
- **Must provide either one:** `photo_id` `(string)` or `product_id` `(int)` . If both are provided then `photo_id` takes precedence.

Following is a sample response to `/posts/create.json`.

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
      "follow_button": {
        "text": "following",
        "action": "/user/42BDB51/unfollow",
        "state": 1
      }
    },
    "reviews": {
      "action": "/post/1430/reviews",
      "count": "0"
    },
    "": {
      "description": "\"This is a post.\"",
      "brands_description": null,
      "main_image": null,
      "square_thumbnail": null,
      "small_thumbnail": null
    },
    "brands": [
    ],
    "heart": {
      "state": null,
      "action": "/posts/1430/heart"
    },
    "hearts": {
      "count": null,
      "action": "/posts/1430/hearts"
    },
    "users_who_hearted_this": null,
    "vote": {
      "enabled": false,
      "count_votes": 0,
      "verdict": null,
      "pending": null
    },
    "created_at": 1337012650,
    "created_when": "just now",
    "post_type": null
  }
}
```