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
end
