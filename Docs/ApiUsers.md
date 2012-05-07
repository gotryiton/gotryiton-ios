#Users

##Endpoints

### GET `/users/:id`

Show one user

Response

```json
{
	"user": {
		"id": "1DB2BD0",
		"name": "Blair W.",
        "location": "NY, NY",
		"icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/users/1DB2BD0/profile",
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
            "action": "/users/E54E869/unfollow",
            "state": 1
        }
	}
}
```

### POST `/users/:id/update`

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


### GET `/users/:id/profile`

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
            "action": "/users/1DB2BD0/unfollow",
            "state": 1
        },
        'settings_button' : {
            "follow_button" : {
                "text": "following",
                "action": "/users/1DB2BD0/unfollow",
                "state": 1
            },
            "alerts_button" : {
                "text" : "turn alerts on",
                "action" : "users/1DB2BD0/following-alerts-on"
            }
        }
        'following_button' : {
            'count' : 20, 
            'action' : "/users/1DB2BD0/following"
        },
        'followers_button' : {
            'count' : 25, 
            'action' : "/users/1DB2BD0/follwers"
        },
    }
}
```



### POST `/users/auth`

Authenticates the user with the application using a token.

Request

You can either pass the token via a header named 'Authentication' or in a request

```bash
curl -H "Accept: application/v4-json" -H "Authentication: c4b4aase9a82b61d7f041f2ef6b36eb8" gotryiton.com/users/auth
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

### POST `/users/auth/facebook`

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


### POST `/users/auth/janrain`

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


### POST `/users/signup/facebook`

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


### POST `/users/signup/janrain`

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



### GET `/users/:id/follow`

Create a following relationship between the requestor and the id'd user

Response

```json
{
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/users/1DB2BD0/profile",
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
            "action": "/users/1DB2BD0/unfollow",
            "state": 1
        }
    }
}
```

### GET `/users/:id/unfollow`

Discard a following relationship between the requestor and the id'd user

Response

```json
{
    "user": {
        "id": "1DB2BD0",
        "name": "Blair W.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/users/1DB2BD0/profile",
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
            "action": "/users/1DB2BD0/follow",
            "state": 0
        }
    }
}
```

### GET `/users/:id/following`

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
        "action": "/users/1DB2BD0/profile",
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
            "action": "/users/1DB2BD0/follow",
            "state": 0
        }
    },
    {
        "id": "FD120BC",
        "name": "Simon H.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/users/FD120BC/profile",
        "badge": null,
        "follow_button": {
            "text": "follow",
            "action": "/users/FD120BC/follow",
            "state": 0
        }
    },
    {
        "id": "72C9BB",
        "name": "Ashish G.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/users/72C9BB/profile",
        "badge": null,
        "follow_button": {
            "text": "following",
            "action": "/users/72C9BB/unfollow",
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


### GET `/users/:id/followers`

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
        "action": "/users/1DB2BD0/profile",
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
            "action": "/users/1DB2BD0/follow",
            "state": 0
        }
    },
    {
        "id": "FD120BC",
        "name": "Simon H.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/users/FD120BC/profile",
        "badge": null,
        "follow_button": {
            "text": "follow",
            "action": "/users/FD120BC/follow",
            "state": 0
        }
    },
    {
        "id": "72C9BB",
        "name": "Ashish G.",
        "location": "NY, NY",
        "icon": "http://assets.gotryiton.com/img/profile-default.png",
        "action": "/users/72C9BB/profile",
        "badge": null,
        "follow_button": {
            "text": "following",
            "action": "/users/72C9BB/unfollow",
            "state": 1
        }
    },

    ],

    "ui" : {
        "title" : "followers",
        "subtitle" : "you have 3 followers",
        "include_filter_search" : false,
    }
}
```