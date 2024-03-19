# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user
  has_many :attendances
  has_many :event_attendances
  has_many :users, through: :attendances

  validates :name, presence: true, length: { maximum: 255 }
  validates :location, length: { maximum: 255 }
  validates :datetime, presence: true
  validates :description, length: { maximum: 1000 }

  # Association with attendances
  has_many :attendances
  has_many :event_attendances
  has_many :users, through: :event_attendances
end
