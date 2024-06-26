class EventAttendancesController < ApplicationController
  before_action :authenticate_user
  before_action :set_event_attendance, only: [:update]

  def index
    # Retrieve event attendances with eager loading for efficient data retrieval
    event_attendances = @current_user.event_attendances.includes(:event, :user)
    
    # Transform data to desired format
    attendances_data = event_attendances.map do |attendance|
      {
        event_name: attendance.event.name,
        event_date: attendance.event.datetime.strftime("%Y-%m-%d %H:%M:%S"), # Include the event date
        user: {
          name: attendance.user.first_name,
          # Include other user details as needed (e.g., email)
        },
        status: attendance.status
      }
    end
  
    render json: attendances_data, status: :ok
  end
  

  def create
    # Ensure event_id is present in params
    if params[:event_id].blank?
      render json: { errors: ["Event ID is missing"] }, status: :bad_request
      return
    end
  
    event = Event.find(params[:event_id])
  
    # Check if attendance for this event has already been marked
    if EventAttendance.exists?(event: event)
      render json: { message: "Attendance for this event has already been marked" }, status: :unprocessable_entity
      return
    end
  
    params[:event_attendances].each do |attendance_params|
      user_id = attendance_params[:user_id]
      status = attendance_params[:status]
      user = User.find(user_id)
  
      # Create a new attendance record
      EventAttendance.create(event: event, user: user, status: status)
    end
  
    render json: { message: "Attendances marked successfully" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event or user not found' }, status: :not_found
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
