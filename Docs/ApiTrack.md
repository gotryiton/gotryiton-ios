#Config

##Endpoints

### POST `/track/`

Track an event 

Request

Pass 'Authentication' header if a token is available.  Pass 'Tracking-Id' header.  Include visit object:


```json
{
  "track" : {

    "id" : "id_of_event",

    "visit" : {
      "latitude" : 40.720577,
      "longitude" : -74.000478,
      "ios_version" : 5.1,
      "ios_device" : "Iphone 4S",
      "ios_ip" : "1.0.0.10",
      "build_version" : 4.0.0,
    } 
  }
}
```


Response

Api responds with the id that was tracked and the visitor tracking id of the visitor that was tracked

```json
{
	"track": {
    "id" : "id_of_event"
    "visit" {
       "id" : 123454321 
    }
  }
}
```
