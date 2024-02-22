# Sign up(POST)

**_Route- http://127.0.0.1:3000/registrations_**

json body

## Normal User

```{
  "user": {
    "first_name":"name",
    "last_name":"name",
    "email": "email@example.com",
    "password": "password",
    "password_confirmation": "password"
  }
}
```

## Admin User

json body

```{
  "user": {
    "first_name":"name",
    "last_name":"name",
    "email": "email@example.com",
    "password": "password",
    "password_confirmation": "password"
    "role":"admin"
  }
}
```



# Log in (POST)

**_Route- http://127.0.0.1:3000/sessions_**

json body

```{
  "user": {
    "email": "email@example.com",
    "password": "password",
    "password_confirmation": "password"

  }
}
```



# Check login status

***Get- http://127.0.0.1:3000/logged_in_***

## Admin login

***path: http://127.0.0.1:3000/sessions***

```
{
 "user":{
 "email": "susan@example.com",
 "password": "password",
 "password_confrimation": "password"
}
}
```



# Admin Creating Event

**_Post - http://127.0.0.1:3000/events_**

json body

```
{
  "event": {
    "name": "Sample Event",
    "location": "Sample Location",
    "datetime": "2024-02-15T12:00:00",
    "description": "This is a sample event description"
  }
}
```



# Admin checking all events

**_Get - http://127.0.0.1:3000/events_**



# Admin Get all Users in the database

**_Get- http://127.0.0.1:3000/admin/users_**



## Check Mark Attendance of an event

**_post http://127.0.0.1:3000/events/:id/mark_attendance_**

sample json body for that event.

```
{
  "attendance": [
    { "user_id": 1, "status": "present" },
    { "user_id": 2, "status": "absent" },
    { "user_id": 3, "status": "present" }
  ]
}
```

## check attendances

**_GET http://127.0.0.1:3000/events/:id/attendance_list_**


## Sign up (POST)

### Route
- **POST** http://127.0.0.1:3000/registrations

### JSON Body

**Normal User**
```json
{
  "user": {
    "first_name":"name",
    "last_name":"name",
    "email": "email@example.com",
    "password": "password",
    "password_confirmation": "password"
  }
}
```

**Admin User**
```json
{
  "user": {
    "first_name":"name",
    "last_name":"name",
    "email": "email@example.com",
    "password": "password",
    "password_confirmation": "password",
    "role":"admin"
  }
}
```

## Log in (POST)

### Route
- **POST** http://127.0.0.1:3000/sessions

### JSON Body
```json
{
  "user": {
    "email": "email@example.com",
    "password": "password"
  }
}
```

## Logged in User and Status

### Route
- **GET** http://127.0.0.1:3000/logged_in

## Admin Creating Event

### Route
- **POST** http://127.0.0.1:3000/events

### JSON Body
```json
{
  "event": {
    "name": "Sample Event",
    "location": "Sample Location",
    "datetime": "2024-02-15T12:00:00",
    "description": "This is a sample event description"
  }
}
```

## Admin Checking All Events

### Route
- **GET** http://127.0.0.1:3000/events

## Admin Get All Users in the Database

### Route
- **GET** http://127.0.0.1:3000/admin/users

## Check Mark Attendance of an Event

### Route
- **POST** http://127.0.0.1:3000/events/:id/mark_attendance

### Sample JSON Body
```json
{
  "attendance": [
    { "user_id": 1, "status": "present" },
    { "user_id": 2, "status": "absent" },
    { "user_id": 3, "status": "present" }
  ]
}
```

## Check Attendances

### Route
- **GET** http://127.0.0.1:3000/events/:id/attendance_list

