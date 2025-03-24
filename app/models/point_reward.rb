class PointReward < ApplicationRecord
  enum status: {
    available: 0,
    hidden: 1,
    expired: 2
  }

  validates :name, presence: true
  validates :required_points, :quantity, :redeemed, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
end
