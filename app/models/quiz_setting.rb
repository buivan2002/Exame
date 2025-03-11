class QuizSetting < ApplicationRecord
  belongs_to :user
  has_many :quizzes, dependent: :destroy
end
