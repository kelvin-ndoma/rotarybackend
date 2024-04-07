class Admin::EventsController < ApplicationController
    def all_event_attendances
      event = Event.find(params[:event_id])
      attendances = event.event_attendances.includes(:user)
    
      render json: attendances.as_json(include: { 
        user: { only: [:id, :first_name, :last_name, :email] },
        event: { only: [:id, :name, :date] }
      }), status: :ok
    end
  end
  