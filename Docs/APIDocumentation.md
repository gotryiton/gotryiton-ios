# Go Try It On API


## Schema

The api can be accessed directly at `gotryiton.com`. An api request should include an `Accept` header that has the version and content-type requested.

For example a request for the outfits index, in JSON, from the version 4 api would be requested as: 

	$ curl -H "Accept: application/v4-json" gotryiton.com/outfits

If no version is provided, the response will be from the current API version.

A request for `text/html` will always receive a response with the most up to date version from the website.

## Api Responses

The api response will always include the name of the resource requested. An api response will use the following pattern:

```json
{
	"resource_name" : {
		"attribute_1": "value", 
		"attribute_2": "value"
	}
}
```

For example, a response for a single outfit would look like:

```json	
{
	"outfit": {
		"id": 1234,
		"description": "This is an outfit's description",
		"user": {
			"id": 4321,
			"name": "Test User"
		}
	}
}
```

A response for a collection of outfits would look like: 

```json	
{
    "outfits": [
        {	        	
            "id": 1234,
            "description": "This is an outfit's description",
            "user": {
            	"id": 4321,
            	"name": "Test User"
            }
        },
        {
            "id": 5678,
            "description": "This is another outfit's description",
            "user": {
            	"id": 8765,
            	"name": "Some other user"
            }
        }
    ]
}
```
	
## Authentication

For requests that require authentication, a token is required to be passed to the api. The token can be sent as either an `Authentication` header or as a request parameter named `access_token`.

	$ curl -H "Accept: application/v4-json" -H "Authentication: 1234567890" gotryiton.com/super_secret_resource
	
	or
	
	$ curl -H "Accept: application/v4-json" gotryiton.com/super_secret_resource?access_token=1234567890"


## Tracking

For requests that require tracking, a udid should be passed via a `Tracking-Id` header or as a request parameter named `tracking_id`.

    $ curl -H "Accept: application/v4-json" -H "Tracking-Id: 1234567890" gotryiton.com/tracked_resource
    
    or
    
    $ curl -H "Accept: application/v4-json" gotryiton.com/tracked_resource?tracking_id=1234567890"
    

## Pagination

A response that includes a collection of resources will have the ability to be paginated unless otherwise noted in documentation.

A request for a paginated collection should include the offset (id) of the first resource in the collection.

	$ curl -H "Accept: application/v4-json" gotryiton.com/outfits/recent?offset=20

The response will include a `previous_page` and `next_page` attribute, which are the urls of the previous and next page for the collection. If those pages don't exist (this is the first, last, or only page), those attributes will still be sent and will have a null value.

An example where offset is 40

```json
{
    "outfits": [
        {
            "id": 1234,
            "description": "This is an outfit's description",
            "user": {
            	"id": 4321,
            	"name": "Test User"
            }
        },
        {
            "id": 5678,
            "description": "This is another outfit's description",
            "user": {
            	"id": 8765,
            	"name": "Some other user"
            }
        },
		more outfits…
    ],
    "pagination": {
        "previous_page": "http://gotryiton.com/outfits?offset=20",
        "next_page": "http://gotryiton.com/outfits?offset=60"
    }
}
```

Only page:

```json
{
    "outfits": [
        {
    		"id": 1234,
    		"description": "This is an outfit's description",
    		"user": {
    			"id": 4321,
    			"name": "Test User"
    		}
        },
        {
    		"id": 5678,
    		"description": "This is another outfit's description",
    		"user": {
    			"id": 8765,
    			"name": "Some other user"
    		}
        }
    ],
    "pagination": {
        "previous_page": null,
        "next_page": null
    }
}
```