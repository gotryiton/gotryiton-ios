# Photos

## Endpoints

### POST  `/photos/create`
Creates and returns a post object based on passed parameters. Upload a file that's less than equal to 5242880 MB that's in `jpeg` format.

#### Request
```json
{
  "token": "c4b4aase9a82b61d7f041f2ef6b36eb8",
  "image": "<Image Data>"
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