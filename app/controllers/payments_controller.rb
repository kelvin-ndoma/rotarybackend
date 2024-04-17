# app/controllers/payments_controller.r
class PaymentsController < ApplicationController
  before_action :authenticate_user! # Assuming you have user authentication

  # POST /payments
  def create
    # Assuming payment details are received from the Mpesa controller
    @event = Event.find(params[:event_id])
    @user = current_user

    # Assuming payment details are available in the params hash
    @payment = Payment.new(
      amount: params[:amount],
      phone_number: params[:phone_number],
      user: @user,
      event: @event
    )

    if @payment.save
      render json: @payment, status: :created
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end
end
