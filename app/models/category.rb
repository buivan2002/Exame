class Category < ApplicationRecord
  has_many :charts
  has_many :favorites
  has_many :point_rules
  has_many :questions
  has_many :quiz_results
  has_many :quizzes
  has_many :sort_orders
  has_many :statistics
  has_many :unlocked_levels
  has_many :user_answers
end
