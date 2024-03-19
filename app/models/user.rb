class User < ApplicationRecord
  enum role: { normal: 0, admin: 1 }

  has_secure_password
  
  # Validations
  validates :first_name, presence: { message: "can't be blank" }
  validates :last_name, presence: { message: "can't be blank" }
  validates :password_digest, presence: { message: "can't be blank" }
  validates :email, presence: { message: "can't be blank" }, 
                    uniqueness: { message: "must be unique" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email address" }

  # Additional validations
  validates :first_name, :last_name, length: { maximum: 50 }
  validates :email, length: { maximum: 255 }

  # Admin flag
  def admin?
    role == 'admin'
  end

  # Association with events
  has_many :events
  # Association with attendances
  has_many :event_attendances
  has_many :attended_events, through: :event_attendances, source: :event
end
