class Question < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :quiz_questions, dependent: :destroy
  has_many :quizzes, through: :quiz_questions
  has_many :user_answers, dependent: :destroy
end
