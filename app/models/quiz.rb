class Quiz < ApplicationRecord
  belongs_to :category
  belongs_to :quiz_setting
  has_many :quiz_questions, dependent: :destroy
  has_many :questions, through: :quiz_questions
  has_many :quiz_results, dependent: :destroy
  has_many :user_answers, dependent: :destroy
end
