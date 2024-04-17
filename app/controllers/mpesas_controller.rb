class MpesasController < ApplicationController
  require 'rest-client'

  # stkpush
  def stkpush
    phoneNumber = params[:phoneNumber]
    amount = params[:amount]
    url = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
    timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}"
    business_short_code = ENV["MPESA_SHORTCODE"]
    password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
    payload = {
      'BusinessShortCode': business_short_code,
      'Password': password,
      'Timestamp': timestamp,
      'TransactionType': "CustomerPayBillOnline",
      'Amount': amount,
      'PartyA': phoneNumber,
      'PartyB': business_short_code,
      'PhoneNumber': phoneNumber,
      'CallBackURL': "#{ENV["CALLBACK_URL"]}/callback_url",
      'AccountReference': 'Codearn',
      'TransactionDesc': "Payment for Codearn premium"
    }.to_json

    headers = {
      Content_type: 'application/json',
      Authorization: "Bearer #{get_access_token}"
    }

    response = RestClient::Request.new({
      method: :post,
      url: url,
      payload: payload,
      headers: headers
    }).execute do |response, request|
      case response.code
      when 500
        [:error, JSON.parse(response.to_str)]
      when 400
        [:error, JSON.parse(response.to_str)]
      when 200
        [:success, JSON.parse(response.to_str)]
      else
        fail "Invalid response #{response.to_str} received."
      end
    end
    render json: response
  end

  # stkquery
  def stkquery
    url = "https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query"
    timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}"
    business_short_code = ENV["MPESA_SHORTCODE"]
    password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
    payload = {
    'BusinessShortCode': business_short_code,
    'Password': password,
    'Timestamp': timestamp,
    'CheckoutRequestID': params[:checkoutRequestID]
    }.to_json

    headers = {
    Content_type: 'application/json',
    Authorization: "Bearer #{ get_access_token }"
    }

    response = RestClient::Request.new({
    method: :post,
    url: url,
    payload: payload,
    headers: headers
    }).execute do |response, request|
    case response.code
    when 500
    [ :error, JSON.parse(response.to_str) ]
    when 400
    [ :error, JSON.parse(response.to_str) ]
    when 200
      [ :success, JSON.parse(response.to_str) ]
    else
    fail "Invalid response #{response.to_str} received."
    end
    end
    render  json: response
  end
  # Create Payment Record

  # Fetch Access Token
  def fetch_access_token
    url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
    consumer_key = ENV['MPESA_CONSUMER_KEY']
    consumer_secret = ENV['MPESA_CONSUMER_SECRET']
    userpass = Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")

    headers = {
      Authorization: "Basic #{userpass}"
    }

    begin
      response = RestClient.get(url, headers)
      render json: response.body
    rescue RestClient::ExceptionWithResponse => e
      render json: { error: e.response }
    rescue => e
      render json: { error: e.message }
    end
  end

  private


  # def create_payment_record(payment_details)
  #   event = Event.find_by(token: payment_details["event_token"])
  #   user = current_user # Assuming you have current_user defined
  #   amount = payment_details["amount"]
  #   phone_number = payment_details["phone_number"]

  #   payment = Payment.new(
  #     amount: amount,
  #     phone_number: phone_number,
  #     user: user,
  #     event: event
  #   )

  #   if payment.save
  #     payment
  #   else
  #     fail "Failed to create payment record: #{payment.errors.full_messages.join(', ')}"
  #   end
  # end

  
  def generate_access_token_request
    url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
    consumer_key = ENV['MPESA_CONSUMER_KEY']
    consumer_secret = ENV['MPESA_CONSUMER_SECRET']
    userpass = Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")

    headers = {
      Authorization: "Basic #{userpass}"
    }

    res = RestClient::Request.execute(url: url, method: :get, headers: headers)
    res
  end

  def get_access_token
    res = generate_access_token_request
    if res.code != 200
      res = generate_access_token_request
      if res.code != 200
        raise MpesaError, 'Unable to generate access token'
      end
    end
    body = JSON.parse(res, { symbolize_names: true })
    token = body[:access_token]
    AccessToken.destroy_all
    AccessToken.create!(token: token)
    token
  end
end
