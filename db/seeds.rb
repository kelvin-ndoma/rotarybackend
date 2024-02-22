# Create users
User.create([
  { first_name: "John", last_name: "Doe", email: "john@example.com", password: "password", password_confirmation: "password", role: 1 },
  { first_name: "Jane", last_name: "Smith", email: "jane@example.com", password: "password", password_confirmation: "password", role: 0 },
  { first_name: "Alice", last_name: "Johnson", email: "alice@example.com", password: "password", password_confirmation: "password", role: 1 }
])


# Create events
Event.create([
  { name: "Tech Conference", location: "Convention Center", datetime: Time.now + 1.month, description: "Annual tech conference showcasing latest innovations.", user_id: 1 },
  { name: "Charity Gala", location: "Grand Ballroom", datetime: Time.now + 2.months, description: "Fundraising gala for local charity organizations.", user_id: 1 },
  { name: "Art Exhibition", location: "Art Gallery", datetime: Time.now + 3.months, description: "Display of contemporary art pieces.", user_id: 3 }
])

# Create attendances
Attendance.create([
  { event_id: 1, user_id: 2, status: 1, event_datetime: Time.now + 1.month },
  { event_id: 1, user_id: 3, status: 1, event_datetime: Time.now + 1.month },
  { event_id: 2, user_id: 1, status: 1, event_datetime: Time.now + 2.months },
  { event_id: 3, user_id: 1, status: 1, event_datetime: Time.now + 3.months }
])
