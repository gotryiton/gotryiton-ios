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
		"born_in": 1984,
		"is_brand": false,
		"location": "NY, NY",
		"about_me": "Upper east side girl",
		"badges": [
			{
				"id": 9,
				"badge_type": 2,
				"image_url": "http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png",
				"created_at": 1303243414
			}
		],
		"city": "NY",
		"state": "NY",
		"gender": "female",
		"service": "Twitter",
		"auth": false,
		"is_new_user": false
	}
}
```
	
### POST `/users/:id/update`

Update a user. Can send partial data.

Request

```json
{
	"name": "Blair G.",
	"about_me": "Something"
} 
```

Response

```json
{
	"user": {
		"id": "1DB2BD0",
		"name": "Blair G.",
		"born_in": 1984,
		"is_brand": false,
		"location": "California",
		"about_me": "Something",
		"badges": [
			{
				"id": 9,
				"badge_type": 2,
				"image_url": "http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png",
				"created_at": 1303243414
			}
		],
		"city": "NY",
		"state": "NY",
		"gender": "female",
		"service": "Twitter",
		"auth": false,
		"is_new_user": false
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
        "born_in": 1984,
        "is_brand": false,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badges": [
            {
                "id": 9,
                "badge_type": 2,
                "image_url": "http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png",
                "created_at": 1303243414
            }
        ],
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Twitter",
        "auth": true,
        "is_new_user": false
    }
}
```

Error Response

```json
{
	"error": "User could not be authenticated"
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
        "born_in": 1984,
        "is_brand": false,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badges": [
            {
                "id": 9,
                "badge_type": 2,
                "image_url": "http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png",
                "created_at": 1303243414
            }
        ],
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Facebook",
        "auth": true,
        "is_new_user": false
    }
}
```

Error Response

```json
{
	"error": "User could not be authenticated with facebook"
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
        "born_in": 1984,
        "is_brand": false,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badges": [
            {
                "id": 9,
                "badge_type": 2,
                "image_url": "http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png",
                "created_at": 1303243414
            }
        ],
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Twitter",
        "auth": true,
        "is_new_user": false
    }
}
```

Error Response

```json
{
	"error": "User could not be authenticated with janrain"
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
        "born_in": 1984,
        "is_brand": false,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badges": [
            {
                "id": 9,
                "badge_type": 2,
                "image_url": "http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png",
                "created_at": 1303243414
            }
        ],
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Facebook",
        "auth": true,
        "is_new_user": true
    }
}
```

`is_new_user` returns true or false depending on whether the user was newly registered or already had an account.


Error Response

```json
{
	"error": "User could not be authenticated with facebook"
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
        "born_in": 1984,
        "is_brand": false,
        "location": "NY, NY",
        "about_me": "Upper east side girl",
        "badges": [
            {
                "id": 9,
                "badge_type": 2,
                "image_url": "http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png",
                "created_at": 1303243414
            }
        ],
        "city": "NY",
        "state": "NY",
        "gender": "female",
        "service": "Twitter",
        "auth": true,
        "is_new_user": true
    }
}
```

`is_new_user` returns true or false depending on whether the user was newly registered or already had an account.


Error Response

```json
{
	"error": "User could not be authenticated with janrain"
}
```
### GET `/users/:id/icons`
Respondes with a user object, Facebook icon and 20 recent outfit icons, each in their own respective keys.

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