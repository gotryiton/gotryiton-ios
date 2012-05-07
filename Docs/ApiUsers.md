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
