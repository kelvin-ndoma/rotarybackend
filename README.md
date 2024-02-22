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
