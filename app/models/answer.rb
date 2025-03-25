class Answer < ApplicationRecord
  belongs_to :question
  has_many :user_answers, dependent: :destroy

  validates :body, presence: true
  validates :is_correct, inclusion: { in: [true, false] }
end
