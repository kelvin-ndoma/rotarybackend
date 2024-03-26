Rails.application.routes.draw do
  resources :mpesas
  # Sessions routes
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  
  # Custom route for updating user details, mapped to SessionsController's update action
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  patch '/sessions/update', to: 'sessions#update'

 
  
  # Events routes
  resources :events, only: [:index, :show, :create, :update, :destroy] do
    # Nested resources for event_attendances
    resources :event_attendances, only: [:create]
  end
  
  # Admin-specific routes
  namespace :admin do
    resources :users do
      # Custom route for listing all users
      get :index, on: :collection
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
