Rails.application.routes.draw do
  root "home#index"
  namespace :users do
    resources :categories, only: [:index, :show] do
      get 'difficulty', on: :member # Thêm trang chọn mức độ
      get 'questions', on: :member # Lấy câu hỏi theo mức độ

    end
  end
  post 'users/save_answer/:id', to: 'users/exams#save_answer', as: 'save_answer'
  get 'users/categories/:id/:difficulty/questions/:question_index', to: 'users/categories#question', as: 'users_question'
  post 'users/categories/:id/:difficulty/questions/:question_index', to: 'users/categories#submit_answer'

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  get 'pages/custom'
  resources :charts
  get "/custom_page", to: "pages#custom"

  namespace :admin do
    get "dashboard", to: "dashboard#index", as: :dashboard
    root "dashboard#index"
    resources :users
    resources :questions
    resources :quizzes
    resources :categories
    resources :quiz_results
    resources :leader_boards
    resources :notifications
  end
end
