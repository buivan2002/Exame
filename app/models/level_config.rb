class LevelConfig < ApplicationRecord
  validates :level, :name, :required_points, :quiz_reward, :login_reward, presence: true
  validates :level, :required_points, :quiz_reward, :login_reward, numericality: { greater_than_or_equal_to: 0}
end
