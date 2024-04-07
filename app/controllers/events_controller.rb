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

  private

  def event_params
    params.require(:event).permit(:name, :location, :datetime, :description)
  end

  def render_record_invalid_response(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
