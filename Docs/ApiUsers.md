#Users

##Endpoints

### GET `/user/:id`

Show one user

Response

```json
{
	"user": {
		"id": "1DB2BD0",
		"name": "Blair W.",
        "location": "NY, NY",
		"icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/1DB2BD0/profile",
		"badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "follow_button": {
            "text": "following",
            "action": "/user/E54E869/unfollow",
            "state": 1
        }
	}
}
```

### POST `/user/:id/update`

Update a user. Can send partial data in the user object.  This api might be used from multiple screens, so a tracking object is also included that sets screen that the api is called from (almost_done, edit_profile, edit_profile_icon) 

Request

```json
{
	"user" : {
        "name": "Blair G.",
        "about_me": "Something"
    },
    "tracking" : {
        "screen" : "almost_done" 
    }
} 
```

Response

```json
{
	"user": {
		"id": "1DB2BD0",
		"name": "Blair G.",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
		"born_in": 1984,
		"is_brand": false,
		"location": "California",
		"about_me": "Something",
		"badge": 
			{
				'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
    		},
		"city": "NY",
		"state": "NY",
		"gender": "female",
		"service": "Twitter",
		"auth": false,
		"is_new_user": false,
        "has_complete_profile" : true
	}
}
```


### GET `/user/:id/profile`

Show one user's profile

Response

```json
{
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "follow_button": {
            "text": "following",
            "action": "/user/1DB2BD0/unfollow",
            "state": 1
        },
        'settings_button' : {
            "follow_button" : {
                "text": "following",
                "action": "/user/1DB2BD0/unfollow",
                "state": 1
            },
            "alerts_button" : {
                "text" : "turn alerts on",
                "action" : "users/1DB2BD0/following-alerts-on"
            }
        }
        'following_button' : {
            'count' : 20, 
            'action' : "/user/1DB2BD0/following"
        },
        'followers_button' : {
            'count' : 25, 
            'action' : "/user/1DB2BD0/follwers"
        },
    }
}
```



### POST `/user/auth`

Authenticates the user with the application using a token.

Request

You can either pass the token via a header named 'Authentication' or in a request

```bash
curl -H "Accept: application/v4-json" -H "Authentication: c4b4aase9a82b61d7f041f2ef6b36eb8" gotryiton.com/user/auth
```

or

```json
{
	"token": "c4b4aase9a82b61d7f041f2ef6b36eb8"
}
```

Response

```json
{
    "token": "c4b4aase9a82b61d7f041f2ef6b36eb8",
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "born_in": 1984,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Twitter",
        "auth": true,
        "is_new_user": false,
        "has_complete_profile" : true
    }
}
```

Error Response

```json
{
   error : {

      status : "error",

      message : "We couldnt log you in for some reason",

      title : "GO TRY IT ON"

   }
} 
```



### GET `/user/me`

Authenticates the user with the application using a token and responds with a user object for that user.

Request

Pass 'Authentication' header if a token is available.  Pass 'Tracking-Id' header.  


Response (current token is authenticated)

```json
{
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "born_in": 1984,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Twitter",
        "auth": true,
        "is_new_user": false,
        "has_complete_profile" : true
    }
}
```

Response (current token is NOT authenticated)

```json
{
   "user": null
} 
```



### POST `/user/auth/facebook`

Authenticates a user with facebook. Responds with token to authenticate directly with the application

Request

```json
{
	"fb_token": "c4b4aase9a82b61d7f041f2ef6b36eb8"
}
```

Response

```json
{
    "token": "c4b4aase9a82b61d7f041f2ef6b36eb8",
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "born_in": 1984,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Facebook",
        "auth": true,
        "is_new_user": false,
        "has_complete_profile" : true
    }
}
```

Error Response

```json
{
   error : {

      status : "error",

      message : "We couldnt log you in via Facebook for some reason",

      title : "GO TRY IT ON"

   }
} 
```


### POST `/user/auth/janrain`

Authenticates a user with janrain. Responds with token to authenticate directly with the application

Request
	
```json
{
	"janrain_token": "c4b4aase9a82b61d7f041f2ef6b36eb8"
}
```

Response

```json
{
    "token": "c4b4aase9a82b61d7f041f2ef6b36eb8",
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "born_in": 1984,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Twitter",
        "auth": true,
        "is_new_user": false,
        "has_complete_profile" : true
    }
}
```

Error Response


```json
{
   error : {

      status : "error",

      message : "We couldnt log you in for some reason",

      title : "GO TRY IT ON"

   }
} 
```


### POST `/user/signup/facebook`

Register a facebook user with the application. If the user already exists, authenticates the user with the application. Responds with token to authenticate directly with the application.

Request
	
```json
{
	"fb_token": "c4b4aase9a82b61d7f041f2ef6b36eb8"
}
```

Response

```json
{
    "token": "c4b4aase9a82b61d7f041f2ef6b36eb8",
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "born_in": 1984,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Facebook",
        "auth": true,
        "is_new_user": true,
        "has_complete_profile" : true
    }
}
```

`is_new_user` returns true or false depending on whether the user was newly registered or already had an account.

`has_complete_profile` returns true or false depending on if the user has all required fields (should or should not skip the almost done screen)


Error Response


```json
{
   error : {

      status : "error",

      message : "We couldnt log you in via Facebook for some reason",

      title : "GO TRY IT ON"

   }
} 
```


### POST `/user/signup/janrain`

Register a janrain user with the application. If the user already exists, authenticates the user with the application. Responds with token to authenticate directly with the application.

Request

```json
{
	"janrain_token": "c4b4aase9a82b61d7f041f2ef6b36eb8"
}
```

Response

```json
{
    "token": "c4b4aase9a82b61d7f041f2ef6b36eb8",
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "born_in": 1984,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Twitter",
        "auth": true,
        "is_new_user": true,
        "has_complete_profile" : true
    }
}
```

`is_new_user` returns true or false depending on whether the user was newly registered or already had an account.

`has_complete_profile` returns true or false depending on if the user has all required fields (should or should not skip the almost done screen)

Error Response


```json
{
   error : {

      status : "error",

      message : "We couldnt log you in for some reason",

      title : "GO TRY IT ON"

   }
} 
```



### GET `/user/:id/follow`

Create a following relationship between the requestor and the id'd user

Response

```json
{
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/1DB2BD0/profile",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "follow_button": {
            "text": "following",
            "action": "/user/1DB2BD0/unfollow",
            "state": 1
        }
    }
}
```


### GET `/user/:id/unfollow`

Discard a following relationship between the requestor and the id'd user

Response

```json
{
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/1DB2BD0/profile",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "follow_button": {
            "text": "follow",
            "action": "/user/1DB2BD0/follow",
            "state": 0
        }
    }
}
```

### GET `/user/:id/following`

Show all users who the id'd user is following. NOTE: the follow_button is contextual to the requestor, not the id'd user.

Response

```json
{
    "users": [
    {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/1DB2BD0/profile",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "follow_button": {
            "text": "follow",
            "action": "/user/1DB2BD0/follow",
            "state": 0
        }
    },
    {
        "id": "FD120BC",
        "name": "Simon H.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/FD120BC/profile",
        "badge": null,
        "follow_button": {
            "text": "follow",
            "action": "/user/FD120BC/follow",
            "state": 0
        }
    },
    {
        "id": "72C9BB",
        "name": "Ashish G.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/72C9BB/profile",
        "badge": null,
        "follow_button": {
            "text": "following",
            "action": "/user/72C9BB/unfollow",
            "state": 1
        }
    },
    ],
    "ui" : {
        "title" : "following",
        "subtitle" : "Blair is following 3 people",
        "include_filter_search" : true,
    }
}
```


### GET `/user/:id/followers`

Show all users who the id'd user is following. NOTE: the follow_button is contextual to the requestor, not the id'd user.

Response

```json
{
    "users": [
    {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/1DB2BD0/profile",
        "badge": 
            {
                'default' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'profile' : 'http://assets.gotryiton.com/img/badges/1/badge-profile-fashionista.png',
                'flat' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'outfit' : 'http://assets.gotryiton.com/img/badges/1/badge-outfit-fashionista.png',
                'shaded' : 'http://assets.gotryiton.com/img/badges/1/badge-shaded-fashionista.png',
                'small' : 'http://assets.gotryiton.com/img/badges/1/badge-review-fashionista.png',
            },
        "follow_button": {
            "text": "follow",
            "action": "/user/1DB2BD0/follow",
            "state": 0
        }
    },
    {
        "id": "FD120BC",
        "name": "Simon H.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/FD120BC/profile",
        "badge": null,
        "follow_button": {
            "text": "follow",
            "action": "/user/FD120BC/follow",
            "state": 0
        }
    },
    {
        "id": "72C9BB",
        "name": "Ashish G.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/user/72C9BB/profile",
        "badge": null,
        "follow_button": {
            "text": "following",
            "action": "/user/72C9BB/unfollow",
            "state": 1
        }
    },

    ],

    "ui" : {
        "title" : "followers",
        "subtitle" : "you have 3 followers",
        "include_filter_search" : false,
    }
```

### GET `/users/:id/icons`
Respondes with a user object, Facebook icon and 20 recent outfit icons, each in their own respective keys.

```json
{
  "user": {
    "id": "7178E1D",
    "name": "Scott B.",
    "location": "NY, New York",
    "icon": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/7f7d77f56c9223755d82be0aa3bf54d0_110_110.jpg",
    "action": "/users/7178E1D",
    "follow_button": {
      "text": "follow",
      "action": "/users/7178E1D/follow",
      "state": 0
    }
  },
  "facebook_icon": {
    "url": "http://graph.facebook.com/1240629055/picture",
    "width": 50,
    "height": 50
  },
  "outfit_icons": [
    {
      "url": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/3acb06d6c75c5cd709a51055c2ff0d26_110_110.jpg",
      "width": 110,
      "height": 110
    },
    {
      "url": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/7f7d77f56c9223755d82be0aa3bf54d0_110_110.jpg",
      "width": 110,
      "height": 110
    },
    {
      "url": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/589d8ec3ef179acafda2954a0c7fdaea_110_110.jpg",
      "width": 110,
      "height": 110
    },
    {
      "url": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/a096c7c7f78435bc14c6346cc25ef452_110_110.jpg",
      "width": 110,
      "height": 110
    },
    {
      "url": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/0ab9dbcc93ed489c49cab5d7e2b5763a_110_110.jpg",
      "width": 110,
      "height": 110
    },
    {
      "url": "http://stage.assets.gotryiton.s3.amazonaws.com/outfits/a8f2fd1116cf7fca5d8a590726773978_110_110.jpg",
      "width": 110,
      "height": 110
    }
  ]

}
```