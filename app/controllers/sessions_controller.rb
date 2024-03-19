# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  include CurrentUserConcern

  # Create a session for a logged-in user
  def create
    user = User.find_by(email: params.dig("user", "email"))

    if user && user.authenticate(params.dig("user", "password"))
      session[:user_id] = user.id
      render json: {
        status: :created,
        logged_in: true,
        user: user.as_json(only: [:id, :first_name, :email, :role]) # Include the user's role in the response
      }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # Check if user is logged in
  def logged_in
    if @current_user
      response_data = { logged_in: true, user: @current_user.as_json(only: [:id, :first_name, :email, :role]) }
      if @current_user.admin?
        response_data[:users] = User.all.as_json(only: [:id, :first_name, :email, :role])
      end
      render json: response_data
    else
      render json: { logged_in: false }
    end
  end

  # Logout a user
  def logout
    reset_session
    render json: {
      status: 200,
      logged_out: true
    }
  end

  # Update user details
  def update
    if @current_user.update(user_params)
      render json: @current_user
    else
      render json: @current_user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit( :first_name, :email, :password, :password_confirmation)
  end
end
