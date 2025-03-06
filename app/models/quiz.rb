class Quiz < ApplicationRecord
  belongs_to :category
  belongs_to :quiz_setting
  has_many :quiz_questions
  has_many :quiz_results
  has_many :user_answers
end
