
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

