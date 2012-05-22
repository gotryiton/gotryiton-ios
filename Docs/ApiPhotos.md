# Photos

## Endpoints

### POST  `/photos/create`
Creates and returns a post object based on passed parameters. Upload a file that's less than equal to 5242880 MB that's in `jpeg` format.  Include a boolean representing whether the user used frames in their upload.  Include the filter name of the filter a user applied to the photo.

#### Request
```json
{
  "image": "<Image Data>",
  "using_filter" : "FilterName",
  "using_frame" : true
}
```

#### Response
```json
{
  "photo": {
    "id": "E15F09D",
    "user_id": "A23CC82",
    "url": "/path/to/image.jpg",
    "width": 640,
    "height": 852
  }
}
```

#### Error
```json
{
  "error": "No valid file found"
}
```