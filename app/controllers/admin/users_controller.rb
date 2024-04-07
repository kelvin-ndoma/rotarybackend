# app/controllers/admin/users_controller.rb
class Admin::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  before_action :authenticate_admin

  def index
    users = User.all
    render json: users, status: :ok
  end

  private

  # Method to handle rendering invalid records
  def render_record_invalid_response(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # Method to ensure only admin can access the controller
  def authenticate_admin
    user = User.find_by(id: session[:user_id])
    unless user && user.admin?
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end
end
