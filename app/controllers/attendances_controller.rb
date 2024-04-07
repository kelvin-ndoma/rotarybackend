class AttendancesController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_user, only: [:index]

  # Action to retrieve attendance records
  def index
    if current_user.admin?
      # Admin can retrieve all attendance records
      attendances = Attendance.all
    else
      # Normal user can only retrieve their own attendance records
      user = User.find(params[:user_id])
      attendances = user.attendances
    end
    render json: attendances, status: :ok
  end

  private

  # Ensure the current user can only retrieve their own attendance records
  def authorize_user
    unless current_user.admin? || current_user.id.to_s == params[:user_id]
      render json: { errors: ["Not authorized to access this resource"] }, status: :unauthorized
    end
  end
end
