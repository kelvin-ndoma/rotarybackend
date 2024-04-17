# app/models/payment.rb

class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :event

  # Validation for presence of essential attributes
  validates :amount, :phone_number, presence: true

  # Method to initiate the payment process
  def initiate_payment(user, event)
    # Save the payment details along with associated user and event
    self.user_id = user.id
    self.event_id = event.id
    save!

    response = MpesasController.new.stkpush(amount, phone_number)

    if response[:status] == :success
      initiate_query(response[:checkout_request_id])
    else
      # Handle failure case (e.g., render error response, raise exception, etc.)
      # For demonstration purposes, let's raise an exception
      raise "STK push failed: #{response[:error]}"
    end
  end

  private

  # Method to initiate the query process
  def initiate_query(checkout_request_id)
    MpesasController.new.stkquery(checkout_request_id)
  end
end
