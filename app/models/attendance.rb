# app/models/attendance.rb
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum status: { present: 0, absent: 1, apology: 2 }

  # Ensure the date of the event is stored in the attendance
  delegate :datetime, to: :event, prefix: true

  # Validations
  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :status, presence: true
  validate :validate_event_datetime_presence

  private

  # Custom validation to ensure event datetime is present
  def validate_event_datetime_presence
    unless event_datetime.present?
      errors.add(:event_datetime, "can't be blank")
    end
  end
end
