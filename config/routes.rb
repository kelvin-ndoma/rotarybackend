Rails.application.routes.draw do
  # Sessions routes
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]

  # Custom routes for sessions
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  patch '/sessions/update', to: 'sessions#update'

  # Mpesas routes
  resources :mpesas
  post 'stkpush', to: 'mpesas#stkpush'
    post 'stkquery', to: 'mpesas#stkquery'
  
  # Events routes
  resources :events, only: [:index, :show, :create, :update, :destroy] do
    resources :event_attendances, only: [:create]
  end
  
  # Admin-specific routes
  namespace :admin do
    resources :users do
      get :index, on: :collection # Custom route for listing all users
    end
    # Add any additional admin resources here
  end

  # Route for users to access their own event attendances
  resources :users, only: [] do
    resources :event_attendances, only: [:index]
  end

  # Root route
  root to: "static#home"
  
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
