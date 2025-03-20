Rails.application.routes.draw do
  root "home#index"
  namespace :users do
    resources :categories, only: [:index, :show] do
      get 'difficulty', on: :member # Thêm trang chọn mức độ
      # get 'questions', on: :member # Lấy câu hỏi theo mức độ

    end
  end
  # post 'users/save_answer/:id', to: 'users/exams#save_answer', as: 'save_answer'
  get 'users/categories/:id/:difficulty/questions/:question_index', to: 'users/categories#question', as: 'users_question'
  post 'users/categories/:id/:difficulty/questions/:question_index', to: 'users/categories#submit_answer'
  get 'users/profile/:id' , to: 'users/profile#show' , as: 'profile'
  get 'users/history', to: 'users/history#index', as: 'history'
  get 'users/history/detail/:id', to: 'users/history#detail', as: 'history_detail'   # id nay la cua quizz result
  get 'users/profile/rank/score', to: 'users/profile#rank_score', as: 'rank_score' # nếu chỉ đặt là profile/rank thì sẽ sai nó sẽ cho cái rank = :id
  get '/users/follow/:id', to: 'users/follows#follow', as: 'follow'
  delete '/users/unfollow/:id', to: 'users/follows#unfollow', as: 'unfollow'
  delete '/users/unfollow/serach/:id', to: 'users/follows#unfollow_serach'
  delete '/users/remove_follower/:id', to: 'users/follows#remove_follower', as: 'remove_follower'
  get 'users/profile/:id/statistics' , to: 'users/profile#statistics' , as: 'profile_statistics' 
  get 'users/profile/statistics/:id' , to: 'users/profile#detail_statistics' , as: 'detail_statistics' 
  post 'users/favorites' , to: 'users/favorites#toggle' 
  post 'users/notifications/:id/mark_as_read', to: 'users/notifications#mark_as_read'
  get "/users/:id/search", to: "users/search#elastic"
  get "/users/search/detail", to: "users/search#detail"
  


  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  namespace :admin do
    # root "dashboard#index"
    get "dashboard" => "dashboard#index"
    # get "profile" => "profile#show"
    resources :profile, ony: [:show, :edit, :update]
    resources :users
    resources :questions
    resources :quizzes
    resources :categories
    resources :quiz_results
    resources :leader_boards
    resources :notifications
  end
end
