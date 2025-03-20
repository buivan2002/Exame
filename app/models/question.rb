class Question < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy, inverse_of: :question
  has_many :quiz_questions, dependent: :destroy
  has_many :quizzes, through: :quiz_questions
  has_many :user_answers, dependent: :destroy
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

end
