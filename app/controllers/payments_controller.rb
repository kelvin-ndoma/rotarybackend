class PaymentsController < ApplicationController
  include MpesaComponent
  include CurrentUserConcern
  
  before_action :set_current_user
  before_action :authorize_admin, only: [:index]
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  def create
    user_id = params[:user_id]
    event_id = params[:event_id]
    amount = params[:amount]
    phoneNumber = params[:phoneNumber] # Fetch phoneNumber parameter

    # Validate user and event existence
    user = User.find_by(id: user_id)
    event = Event.find_by(id: event_id)

    unless user && event
      render json: { error: 'User or event not found' }, status: :unprocessable_entity
      return
    end

    # Create a payment record
    payment = Payment.new(
      user_id: user_id,
      event_id: event_id,
      amount: amount
    )

    if payment.save
      # Initiate MPESA payment
      response = stkpush(phoneNumber, amount) # Pass phoneNumber and amount to stkpush
      render json: response, status: :created
    else
      render json: { error: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # View all payments for an event (Admin only)
  def index
    event = Event.find(params[:event_id])

    if event
      payments = event.payments
      render json: payments, status: :ok
    else
      render json: { error: 'Event not found' }, status: :not_found
    end
  end

  private

  # Check if the current user is an admin
  def authorize_admin
    unless current_user.admin?
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end

  def set_current_user
    @current_user = session[:user_id] ? User.find_by(id: session[:user_id]) : nil
  end
end
