class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  after_commit :update_elasticsearch, on: [:create, :destroy]

  private

  def update_elasticsearch
    puts "🔥 Cập nhật index cho follower: #{follower.id} và followed: #{followed.id}"
    followed.__elasticsearch__.index_document
  end
end
