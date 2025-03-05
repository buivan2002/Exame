Rails.application.routes.draw do
  get 'pages/custom'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :charts 
  # Defines the root path route ("/")
  # root "articles#index"
  get "/custom_page", to: "pages#custom"

  
end
