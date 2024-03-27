class MpesasController < ApplicationController
  require 'rest-client'

  # stkpush
  def stkpush
    phoneNumber = params[:phoneNumber]
    amount = params[:amount]
    url = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    business_short_code = ENV["MPESA_SHORTCODE"]
    password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
    payload = {
      BusinessShortCode: business_short_code,
      Password: password,
      Timestamp: timestamp,
      TransactionType: "CustomerPayBillOnline",
      Amount: amount,
      PartyA: phoneNumber,
      PartyB: business_short_code,
      PhoneNumber: phoneNumber,
      CallBackURL: "#{ENV["CALLBACK_URL"]}/callback_url",
      AccountReference: 'Codearn',
      TransactionDesc: "Payment for Codearn premium"
    }.to_json

    headers = {
      content_type: 'application/json',
      Authorization: "Bearer #{get_access_token}"
    }

    response = RestClient::Request.execute(
      method: :post,
      url: url,
      payload: payload,
      headers: headers
    )

    render json: response
  end

  # stkquery
  def stkquery
    url = "https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    business_short_code = ENV["MPESA_SHORTCODE"]
    password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
    payload = {
      BusinessShortCode: business_short_code,
      Password: password,
      Timestamp: timestamp,
      CheckoutRequestID: params[:CheckoutRequestID]
    }.to_json

    headers = {
      content_type: 'application/json',
      Authorization: "Bearer #{get_access_token}"
    }

    response = RestClient::Request.execute(
      method: :post,
      url: url,
      payload: payload,
      headers: headers
    )

    case response.code
    when 200
      render json: { status: :success, data: JSON.parse(response.body) }
    when 400, 500
      render json: { status: :error, data: JSON.parse(response.body) }
    else
      render json: { status: :error, message: "Invalid response: #{response.code}" }
    end
  end

  private

  def generate_access_token_request
    url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
    consumer_key = ENV['MPESA_CONSUMER_KEY']
    consumer_secret = ENV['MPESA_CONSUMER_SECRET']
    userpass = Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")

    RestClient::Request.execute(
      url: url,
      method: :get,
      headers: {
        Authorization: "Basic #{userpass}"
      }
    )
  end

  def get_access_token
    res = generate_access_token_request
    unless res.code == 200
      raise "Unable to generate access token"
    end

    body = JSON.parse(res.body, symbolize_names: true)
    token = body[:access_token]

    AccessToken.destroy_all
    AccessToken.create!(token: token)
    token
  end
end
