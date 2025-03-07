Rails.application.routes.draw do
  root "charts#index"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  get 'pages/custom'
  namespace :admin do
    get 'dashboard', to: 'dashboard#index' # Điều hướng đến Admin::DashboardController#index
  end
  resources :charts
  resources :charts 
  get "/custom_page", to: "pages#custom"
  
end
