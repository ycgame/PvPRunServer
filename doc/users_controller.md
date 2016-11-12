## POST /users
Create user.

### Example

#### Request
```
POST /users HTTP/1.1
Content-Length: 11
Content-Type: application/x-www-form-urlencoded
Host: test.host
User-Agent: Rails Testing

token=dummy
```

#### Response
```
HTTP/1.1 403
Content-Type: text/html
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
```

## POST /users
Update name.

### Example

#### Request
```
POST /users/1/name HTTP/1.1
Content-Length: 19
Content-Type: application/x-www-form-urlencoded
Host: test.host
User-Agent: Rails Testing

name=OK&token=dummy
```

#### Response
```
HTTP/1.1 200
Content-Type: application/json; charset=utf-8
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block

{
  "token": "dummy",
  "id": 1,
  "name": "OK",
  "rate": null,
  "time_attack": null,
  "created_at": "2016-11-12T14:54:36.798+09:00",
  "updated_at": "2016-11-12T14:54:36.806+09:00"
}
```
