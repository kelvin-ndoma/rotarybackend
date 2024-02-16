# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  before_action :require_admin
  before_action :set_current_user

  def index
    users = User.all
    render json: users, status: :ok
  end

  private

  def require_admin
    user = User.find_by(email: params.dig("user", "email"))
    unless user&.admin?
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end
  

  # Move this method to ApplicationController or create a concern if it's reused
  def set_current_user
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
