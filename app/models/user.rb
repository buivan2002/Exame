class User < ApplicationRecord
  has_many :auth_logs
  has_many :charts
  has_many :favorites
  has_many :follows, foreign_key: "follower_id"
  has_many :followers, class_name: "Follow", foreign_key: "followed_id"
  has_one :leader_boards
  has_many :notifications
  has_many :point_histories
  has_one :points
  has_many :quiz_results
  has_one :quiz_settings
  has_many :sort_orders
  has_many :statistics
  has_many :unlocked_levels
  has_many :user_answers
end
