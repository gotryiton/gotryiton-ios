# Posts

## Endpoints

### GET  `/posts/feed(/~page/~limit)`
Gets feed of the logged in user.

- The maximum limit is 20 and defaults to the same if no limit is specified.
- Pages are numbered from 1 and it defaults to the first page if no page is specified.
- The `change_it` and `wear_it` button keys are absent if voting is disabled.

Following is a sample response for `/posts/feed/page/1/limit/1` for user with id 1426.

	{
	  "feed": [
	    {
	      "id": 1426,
	      "user": {
	        "id": "DD7CFD2",
	        "name": "Simon H.",
	        "location": "Brooklyn, New York",
	        "user_icon": "http://graph.facebook.com/1702642/picture",
	        "badges": [
	        ],
	        "action": "/users/DD7CFD2",
	        "following_button": {
	          "text": "following",
	          "action": "/users/DD7CFD2/unfollow",
	          "state": 1
	        }
	      },
	      "reviews": {
	        "action": "/post/1426/reviews",
	        "count": "6"
	      },
	      "outfit": {
	        "description": "Bubba",
	        "brands_description": "",
	        "main_image": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/6a69d89150893715f4d7520bc3618df4.jpg",
	        "square_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/6a69d89150893715f4d7520bc3618df4_110_110.jpg",
	        "small_thumbnail": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/6a69d89150893715f4d7520bc3618df4_101_131.jpg"
	      },
	      "brands": [
	      ],
	      "heart": {
	        "state": "0",
	        "action": "/posts/1426/heart"
	      },
	      "hearts": {
	        "count": "0",
	        "action": "/posts/1426/hearts"
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
	          "action": "/post/1426/vote/wear-it"
	        },
	        "change_it": {
	          "count": 0,
	          "state": 0,
	          "action": "/post/1426/vote/change-it"
	        }
	      },
	      "created_at": 1334616796,
	      "created_when": "3 weeks ago",
	      "post_type": "outfit"
	    }
	  ]
	}