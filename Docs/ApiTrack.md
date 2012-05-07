#Config

##Endpoints

### GET `/track/:event_id`

Track an event with :event_id

Request

Pass 'Authentication' header if a token is available.  Pass 'Tracking-Id' header.  Include visit object:


```json
{
    "visit" : {
      "latitude" : 40.720577,
      "longitude" : -74.000478,
      "ios_version" : 5.1,
      "ios_device" : "Iphone 4S",
      "ios_ip" : "1.0.0.10",
      "build_version" : 4.0.0,
    } 
}
```


Response

```json
{
	"event": ":event_id"
    "id" : 123454321
}
```
