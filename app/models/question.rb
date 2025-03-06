class Question < ApplicationRecord
  belongs_to :category
  has_many :answers
  has_many :quiz_questions
  has_many :user_answers
end
