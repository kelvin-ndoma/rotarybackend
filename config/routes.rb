Rails.application.routes.draw do
  # Sessions routes
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]

  # Custom routes for sessions
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  patch '/sessions/update', to: 'sessions#update'

  # Route for creating payments
  post 'payments', to: 'payments#create'
  # Mpesas routes
  resources :mpesas
  post 'stkpush', to: 'payments#stkpush' # Updated route to use the Payments controller
  post 'stkquery', to: 'payments#stkquery' # Updated route to use the Payments controller

  # Events routes
  resources :events, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'attendance_list', to: 'event_attendances#attendance_list'  # New route for attendance list of a specific event
      get 'attendances', to: 'event_attendances#attendances_for_event'  # New route for retrieving attendances for a specific event
    end
    resources :event_attendances, only: [:create, :update]
  end

  # Admin-specific routes
  namespace :admin do
    resources :users do
      get 'all_event_attendances', to: 'users#all_event_attendances'
    end

    # Consolidate the event attendances route under the events namespace
    resources :events do
      get 'all_event_attendances', to: 'events#all_event_attendances'  # Route to fetch all attendances for a specific event
      get 'attendances', to: 'event_attendances#attendances_for_event' # Route to fetch attendances for a specific event
    end
  end

  # Route for users to access their own event attendances
  resources :users, only: [] do
    resources :event_attendances, only: [:index]
    # New route for a specific event and user's attendances
    get 'events/:event_id/attendances', to: 'event_attendances#user_attendances_for_event'
  end

  # Route to retrieve attendance records for a specific event
  get 'events/:event_id/event_attendances', to: 'attendances#index'

  # Root route
  root to: "static#home"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
