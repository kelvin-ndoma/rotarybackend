class PaymentsController < ApplicationController
    before_action :set_user, only: [:new, :create]
  
    # GET /payments/new
    # Display form to make a new payment
    def new
      @payment = Payment.new
    end
  
    # POST /payments
    # Create a new payment
    def create
      @payment = @user.payments.new(payment_params)
  
      if @payment.save
        # Initiating payment process
        @payment.initiate_payment(params[:payment][:phone_number])
        redirect_to @payment, notice: 'Payment was successfully created.'
      else
        render :new
      end
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end
  
    # Only allow a list of trusted parameters through.
    def payment_params
      params.require(:payment).permit(:amount, :event_id)
    end
  end
  