Rails.application.routes.draw do
  root "charts#index"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    omniauth_callbacks: 'users/omniauth_callbacks' ,
  }
    get 'pages/custom'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :charts 
  # Defines the root path route ("/")
  # root "articles#index"
  get "/custom_page", to: "pages#custom"
  
end
