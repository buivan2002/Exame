class Category < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :quizzes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :statistics, dependent: :destroy
  has_many :point_rules, dependent: :destroy
  has_many :unlocked_levels, dependent: :destroy
end
