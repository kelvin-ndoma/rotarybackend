class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :event

  # Validation for amount presence
  validates :amount, presence: true

  # Method to initiate the payment process
  def initiate_payment(phone_number)
    MpesasController.new.stkpush(self, phone_number)
  end
end
