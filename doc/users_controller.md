## POST /users
Create user.

### Example

#### Request
```
POST /users HTTP/1.1
Content-Length: 10
Content-Type: application/x-www-form-urlencoded
Host: test.host
User-Agent: Rails Testing

name=test1
```

#### Response
```
HTTP/1.1 200
Content-Type: application/json; charset=utf-8
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block

{
  "id": 1,
  "name": "test1",
  "token": "1b7f0797fce8d47c900c3beb3bc33f5f",
  "created_at": "2016-10-24T12:41:00.705Z",
  "updated_at": "2016-10-24T12:41:00.705Z"
}
```
