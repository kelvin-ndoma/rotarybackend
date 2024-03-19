class AttendancesController < ApplicationController
  before_action :authenticate_admin, only: [:create, :update]

  def index
    # Retrieve all attendances from the database
    attendances = Attendance.all
    render json: attendances, status: :ok
  end
  # POST /attendances
  def create
    # Ensure event_id is present in params
    if params[:event_id].blank?
      render json: { errors: ["Event ID is missing"] }, status: :bad_request
      return
    end

    event = Event.find(params[:event_id])

    # Find all users for the event who don't already have attendance records
    users_without_attendance = User.where.not(id: event.attendances.pluck(:user_id))

    # Create attendance records for all eligible users with a default status
    Attendance.create!(users_without_attendance.map do |user|
      { event: event, user: user, status: 'absent' }
    end)

    # Update attendance records based on user_ids and statuses from the request
    params[:attendances].each do |attendance_params|
      user_id = attendance_params[:user_id]
      status = attendance_params[:status]
      user = User.find(user_id)
      attendance = event.attendances.find_by!(user: user)
      attendance.update!(status: status)
    end

    render json: { message: "Attendance marked successfully" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end
  # PATCH /attendances/:id
  def update
    attendance = Attendance.find(params[:id])
    if attendance.update(attendance_params)
      render json: attendance, status: :ok
    else
      render json: { errors: attendance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def attendance_params
    params.require(:attendance).permit(:user_id, :event_id, :status)
  end

  def authenticate_admin
    user = User.find_by(id: session[:user_id])
    unless user && user.admin?
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end
end
