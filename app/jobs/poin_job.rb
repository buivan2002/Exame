class PoinJob  < ApplicationJob
  queue_as :poin
  sidekiq_options retry: 3  # Chỉ retry tối đa 3 lần

  def perform(user_id, category_id, difficulty)
    user = User.find(user_id)
    category = Category.find(category_id)
      # Lấy số điểm từ PointRule - hiện tại đang cứ làm bài xong là cộng điểm như này chứ không có phân loại đúng sai gì cả - đáng ra nên cộng bằng điểm thì hợp lý hơn 
    points_awarded = PointRule.where(category_id: category.id, difficulty: difficulty).pluck(:point_awarded).first || 0
      # Tìm hoặc tạo Point record cho user
    point = Point.find_or_create_by(user_id: user.id)
      # Cộng thêm điểm vào total_point
    new_total = point.total_point.to_i + points_awarded
    new_level = case new_total
    when 0...50 then 1
    when 50...100 then 2
    when 100..150 then 3
    else 4
    end

    # Cập nhật total_point và level
    point.update(total_point: new_total, level: new_level)
    user.point_histories.create(
    point: points_awarded,
    reason: "Điểm thưởng hoàn thành mức #{difficulty}",
    status: :unused  # Giả sử status có enum { use: 0, unused: 1 }

  )
  Rails.logger.info "✅✅ point created for User ##{user_id}, poin #{new_total}"

  end 
end 