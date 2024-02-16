Rails.application.routes.draw do
  # Sessions routes
  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  
  # Custom route for updating user details, mapped to SessionsController's update action
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  patch '/sessions/update', to: 'sessions#update'
  
  # Events routes
  resources :events, only: [:index, :show, :create, :update, :destroy] do
    # Custom routes for marking attendance and listing attendance
    post :mark_attendance, on: :member
    get :attendance_list, on: :member
  end

  # Admin-specific routes
  namespace :admin do
    resources :users do
      # Custom route for listing all users
      get :index, on: :collection
    end
    # Add any additional admin resources here
  end

  root to: "static#home"
  get "up" => "rails/health#show", as: :rails_health_check
end
