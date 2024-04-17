Rails.application.routes.draw do
  # Sessions routes
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]

  # Custom routes for sessions
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  patch '/sessions/update', to: 'sessions#update'

  # Route for creating payments
  resources :payments, only: [:index, :create]  # Adjusted to allow both index and create actions

  # Mpesas routes
  post 'stkpush', to: 'mpesas#stkpush'
  post 'stkquery', to: 'mpesas#stkquery'
  post 'mpesa/callback', to: 'payments#callback'
  post 'fetch_access_token', to: 'mpesas#fetch_access_token'  # Added route for fetching access token

  # Events routes
  resources :events, only: [:index, :show, :create, :update, :destroy] do
    member do
      get 'attendance_list', to: 'event_attendances#attendance_list'
      get 'attendances', to: 'event_attendances#attendances_for_event'
    end
    resources :event_attendances, only: [:create, :update]
  end

  # Admin-specific routes
  namespace :admin do
    resources :users do
      get 'all_event_attendances', to: 'users#all_event_attendances'
    end

    resources :events do
      get 'all_event_attendances', to: 'events#all_event_attendances'
      get 'attendances', to: 'event_attendances#attendances_for_event'
    end

    # Route for admins to view all payments
    resources :payments, only: [:index, :create] # Added route for admins to view all payments
  end
 
  # Route for users to access their own payments
  resources :users, only: [] do
    resources :payments, only: [:index, :create]  # Added route for users to view their own payments
  end

  get '/retrieve_payment', to: 'payments#retrieve_payment'
  post '/store_payment', to: 'payments#store_payment'

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
