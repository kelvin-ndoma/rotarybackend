class EventAttendancesController < ApplicationController
  before_action :authenticate_user
  before_action :set_event_attendance, only: [:update]

  def index
    # Retrieve event attendances for the current user
    event_attendances = @current_user.event_attendances
    render json: event_attendances, status: :ok
  end

  def create
    # Ensure event_id is present in params
    if params[:event_id].blank?
      render json: { errors: ["Event ID is missing"] }, status: :bad_request
      return
    end

    event = Event.find(params[:event_id])

    # Find all users for the event who don't already have attendance records
    users_without_attendance = event.users.where.not(id: event.event_attendances.pluck(:user_id))

    # Create attendance records for all eligible users with a default status
    EventAttendance.transaction do
      users_without_attendance.each do |user|
        EventAttendance.create!(event: event, user: user, status: 'absent')
      end
    end

    render json: { message: "Attendance marked successfully" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  def update
    if @event_attendance.update(event_attendance_params)
      render json: @event_attendance, status: :ok
    else
      render json: { errors: @event_attendance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_event_attendance
    @event_attendance = EventAttendance.find(params[:id])
  end

  def event_attendance_params
    params.require(:event_attendance).permit(:user_id, :event_id, :status)
  end

  def authenticate_user
    @current_user = User.find_by(id: session[:user_id])
    unless @current_user
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end
end
