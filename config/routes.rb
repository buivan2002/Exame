Rails.application.routes.draw do
  root "home#index"
  namespace :users do
    resources :categories, only: [:index, :show] do
      get 'difficulty', on: :member # Thêm trang chọn mức độ
      get 'questions', on: :member # Lấy câu hỏi theo mức độ

    end
  end
  get 'users/categories/:id/:difficulty/questions/:question_index', to: 'users/categories#question', as: 'users_question'
  post 'users/categories/:id/:difficulty/questions/:question_index', to: 'users/categories#submit_answer'

  
  # get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # root "charts#index"
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
