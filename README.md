Sign up-POST

Route- http://127.0.0.1:3000/registrations

json body 

Normal User
{
  "user": {
    "first_name":"name",
    "last_name":"name",
    "email": "email@example.com",
    "password": "password",
    "password_confirmation": "password"
  }
}

Admin User
{
  "user": {
    "first_name":"name",
    "last_name":"name",
    "email": "email@example.com",
    "password": "password",
    "password_confirmation": "password"
    "role":"admin"
  }
}

Log in  POST

Route- http://127.0.0.1:3000/sessions

{
  "user": {
    "email": "email@example.com",
    "password": "password",
    "password_confirmation": "password"
   
  }
}

Logged in User and Status

Get- http://127.0.0.1:3000/logged_in

Admin Creating Event 

Post - http://127.0.0.1:3000/events

{
  "event": {
    "name": "Sample Event",
    "location": "Sample Location",
    "datetime": "2024-02-15T12:00:00",
    "description": "This is a sample event description"
  }
}

Admin checking all events

Get - http://127.0.0.1:3000/events

Admin Get all Users in the database
Get- http://127.0.0.1:3000/admin/users

Check Mark Attendance of an event

post http://127.0.0.1:3000/events/:id/mark_attendance


sample json body for that event.
{
  "attendance": [
    { "user_id": 1, "status": "present" },
    { "user_id": 2, "status": "absent" },
    { "user_id": 3, "status": "present" }
  ]
}

check attendances

GET http://127.0.0.1:3000/events/:id/attendance_list



