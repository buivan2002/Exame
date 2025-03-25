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
  delete '/users/unfollow/:id', to: 'users/follows#unfollow', as: 'unfollow'
  delete '/users/remove_follower/:id', to: 'users/follows#remove_follower', as: 'remove_follower'
  get 'users/profile/:id/statistics' , to: 'users/profile#statistics' , as: 'profile_statistics'
  get 'users/profile/statistics/:id' , to: 'users/profile#detail_statistics' , as: 'detail_statistics'


  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  namespace :admin do
    # root "dashboard#index"
    get "dashboard" => "dashboard#index"

    get "dashboard/all_score" => "dashboard#all_score"
    resources :profile, ony: [:show, :edit, :update]
    resources :users do
      post :reset_password, on: :member
    end
    resources :questions
    resources :quizzes
    resources :categories
    resources :quiz_results
    resources :leader_boards
    resources :notifications
    resources :points, only: [:index]

    get "histories" => "histories#index"
    get "setting" => "setting#index"

    post "points/level_configs/add" => "level_configs#create", as: "add_level_config"
    get "points/level_configs/:id/edit" => "level_configs#edit", as: "edit_level_config"
    patch "points/level_configs/:id" => "level_configs#update", as: "update_level_config"
    delete "points/level_configs/:id" => "level_configs#destroy", as: "delete_level_config"

    post "points/point_rewards/add" => "point_rewards#create", as: "add_point_reward"
    get "points/point_rewards/:id/edit" => "point_rewards#edit", as: "edit_point_reward"
    patch "points/point_rewards/:id" => "point_rewards#update", as: "update_point_reward"
    delete "points/point_rewards/:id" => "point_rewards#destroy", as: "delete_point_reward"
  end
end
