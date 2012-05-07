#Config

##Endpoints

### GET `/config/`

Show the app config settings

Response

```json
{
	"config": {
		"intro_images": [ 
            {
                'image_url' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'id' : 'app_intro_1',
            },
            {
                'image_url' : 'http://assets.gotryiton.com/img/badges/1/badge-flat-fashionista.png',
                'id' : 'app_intro_2',
            },
        ]
	}
}
```

Error Response

```json
{
   error : {

      status : "error",

      message : "our app is undergoing routine maintenance or something else that means you get a popup",

      title : "GO TRY IT ON"

   }
} 
```


### GET `/config/upload`

Show the app config settings

Response

```json
{
    "config": {
        "voting_default_on": true,
        "facebook_share_default_on": true,
    }
}
```

Error Response

```json
{
   error : {

      status : "error",

      message : "our app is undergoing routine maintenance or something else that means you get a popup",

      title : "GO TRY IT ON"

   }
} 
```