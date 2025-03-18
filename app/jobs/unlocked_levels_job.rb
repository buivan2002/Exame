class UnlockedLevelsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user # Tránh lỗi khi user_id không tồn tại
    # Lấy danh sách các chủ đề và độ khó đang đạt đc của user 
    unlocked_levels = user.unlocked_levels.includes(:user)
    unlocked_levels.each do |unlocked_level|
      quiz_results = QuizResult.joins(:quiz)
                               .where(
                                 user_id: user.id,
                                 category_id: unlocked_level.category_id,
                                 quizzes: { difficulty: unlocked_level.difficulty }
                               )
                               .order(created_at: :desc)
                               .limit(5)
      if quiz_results.size > 4 && quiz_results.sum(&:score) > -1
        next_level = case unlocked_level.difficulty
                     when "easy" then "medium"
                     when "medium" then "hard"
                     else "hard"
                     end
        unlocked_level.update(difficulty: next_level)  # ✅ Cập nhật chính xác bản ghi
      end
    end
    # Xử lý dữ liệu ở đây (ví dụ: gửi email, ghi log, cập nhật database, ...)
    Rails.logger.info("✅✅✅✅User #{user_id} có #{unlocked_levels.count} bản ghi UnlockedLevel.")
  end
end
