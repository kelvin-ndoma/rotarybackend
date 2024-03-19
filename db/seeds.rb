# Seed data for users
User.create([
  { first_name: "John", last_name: "Doe", email: "john@example.com", password: "password", password_confirmation: "password", role: 1 },
  { first_name: "Jane", last_name: "Smith", email: "jane@example.com", password: "password", password_confirmation: "password", role: 0 },
  { first_name: "Alice", last_name: "Johnson", email: "alice@example.com", password: "password", password_confirmation: "password", role: 1 }
])

# Seed data for events
Event.create([
  { name: "Conference", location: "Convention Center", datetime: DateTime.new(2024, 3, 15, 9, 0, 0), description: "Annual conference for industry professionals", user_id: 1 },
  { name: "Workshop", location: "Tech Hub", datetime: DateTime.new(2024, 3, 20, 13, 0, 0), description: "Hands-on workshop on web development", user_id: 2 },
  { name: "Seminar", location: "City Hall", datetime: DateTime.new(2024, 3, 25, 10, 0, 0), description: "Educational seminar on finance management", user_id: 1 }
])

# Seed data for attendances
Attendance.create([
  { event_id: 1, user_id: 1, status: 1, event_datetime: DateTime.new(2024, 3, 15, 9, 0, 0) },
  { event_id: 2, user_id: 2, status: 1, event_datetime: DateTime.new(2024, 3, 20, 13, 0, 0) },
  { event_id: 3, user_id: 1, status: 1, event_datetime: DateTime.new(2024, 3, 25, 10, 0, 0) }
])
