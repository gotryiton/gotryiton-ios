# Photos

## Endpoints

### GET  `/photos/create`
Creates and returns a post object based on passed parameters. Upload a file that's less than equal to 5242880 MB that's in `jpeg` format.

Following is a sample response for `/photos/create`.
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