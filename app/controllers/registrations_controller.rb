class RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)

    # Set admin attribute based on the presence of the 'role' parameter
    user.role = params[:user][:role] || 'normal'

    if user.save
      render json: user, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end
end
