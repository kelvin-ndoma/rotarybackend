class EventsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

  def index
    user = User.find_by(id: session[:user_id])
    if user
      events = Event.all
      render json: events, status: :ok
    else
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  def create
    user = User.find_by(id: session[:user_id])
    if user && user.admin?  # Check if the user exists and is an admin
      event = user.events.build(event_params)
      if event.save
        render json: event, include: :user, status: :created
      else
        render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  def update
    user = User.find_by(id: session[:user_id])
    if user && user.admin?  # Check if the user exists and is an admin
      event = Event.find(params[:id])
      if event.update(event_params)
        render json: event, status: :ok
      else
        render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  def destroy
    user = User.find_by(id: session[:user_id])
    if user && user.admin?  # Check if the user exists and is an admin
      event = Event.find(params[:id])
      event.destroy
      render json: {}, status: :no_content
    else
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end


  # def mark_attendance
  #   user = User.find_by(id: session[:user_id])
  #   event = Event.find(params[:id])
  
  #   if user && user.admin? && event.user == user
  #     params[:attendance].each do |attendance_params|
  #       user_id = attendance_params[:user_id]
  #       status = attendance_params[:status]
  #       user = User.find(user_id)
  #       attendance = Attendance.find_or_initialize_by(event: event, user: user)
  #       attendance.update(status: status)
  #     end
  #     render json: { message: "Attendance marked successfully" }, status: :ok
  #   else
  #     render json: { error: "Not authorized" }, status: :unauthorized
  #   end
  # end
  

  
  
  # def attendance_list
  #   user = User.find_by(id: session[:user_id])
  #   event = Event.find(params[:id])
  
  #   if user && (user.admin? || event.user == user)
  #     if user.admin?
  #       attendances = event.attendances.includes(:user)
  #     else
  #       attendances = event.attendances.where(user: user)
  #     end
  #     render json: attendances, status: :ok
  #   else
  #     render json: { errors: ["Not authorized"] }, status: :unauthorized
  #   end
  # end
  
  
  # private
  
  # def attendance_params
  #   params.permit(attendance: [:user_id, :status])
  # end
  
  

  private

  def event_params
    params.require(:event).permit(:name, :location, :datetime, :description)
  end

  def render_record_invalid_response(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
