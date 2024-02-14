Rails.application.routes.draw do
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  
  # Custom route for updating user details, mapped to SessionsController's update action
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  patch '/sessions/update', to: 'sessions#update'
  
  # Admin-specific routes
  namespace :admin do
    resources :users # Add any additional admin resources here
  end

  root to: "static#home"
  get "up" => "rails/health#show", as: :rails_health_check
end
