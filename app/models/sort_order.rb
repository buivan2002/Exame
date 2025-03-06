class SortOrder < ApplicationRecord
  belongs_to :user
  belongs_to :category
  validates_uniqueness_of :category_id, scope: :user_id, on: :create
end
