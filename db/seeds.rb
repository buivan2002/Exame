# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb
require 'faker'
# db/seeds.rb

puts "Xoá dữ liệu cũ..."
[User, Category, Question, Answer, QuizSetting, Quiz, QuizQuestion,
 QuizResult, UserAnswer, AuthLog, Chart, Favorite, Follow,
 LeaderBoard, Notification, PointHistory, PointRule, Point,
 SortOrder, Statistic, UnlockedLevel].each(&:delete_all)

now = Time.current
# db/seeds.rb
puts "Bắt đầu seed dữ liệu..."

# 1. Tạo tài khoản admin (password: 123456)
admin = User.create!(
  name: "Admin",
  email: "admin@example.com",
  password: "123456",
  role: "admin",
  last_login_at: Time.now,
  avatar_url: "http://example.com/admin_avatar.png",
  oauth_provider: nil,
  oauth_id: nil,
)
puts "Tạo tài khoản admin thành công."

# 2. Tạo 30 tài khoản người dùng (user)
30.times do |i|
  User.create!(
    name: "User #{i+1}",
    email: "user#{i+1}@example.com",
    password: "password#{i+1}",
    role: "user",
    last_login_at: Time.now,
    avatar_url: "http://example.com/user#{i+1}_avatar.png",
    oauth_provider: "none",
    oauth_id: "#{i+1}",
  )
end
puts "Tạo 30 tài khoản người dùng thành công."

# Lấy danh sách người dùng thường (không bao gồm admin)
users = User.where(role: "user").order(:id)

# 3. Tạo 30 bản ghi cho bảng Categories
30.times do |i|
  Category.create!(
    name: "Category #{i+1}",
    description: "Mô tả cho Category #{i+1}",
    status: "active"
  )
end
puts "Tạo 30 bản ghi trong bảng Categories."

# 4. Tạo 30 bản ghi cho bảng Questions
# Mỗi câu hỏi thuộc 1 danh mục (lấy vòng theo danh mục đã tạo)
categories = Category.order(:id)
30.times do |i|
  Question.create!(
    category_id: categories[i % 30].id,
    content: "Nội dung câu hỏi #{i+1}",
    question_type: "multiple_choice",
    difficulty: "medium",
    status: "active",
    explanation: "Giải thích cho câu hỏi #{i+1}",
    image_url: "http://example.com/question#{i+1}.png"
  )
end
puts "Tạo 30 bản ghi trong bảng Questions."

# 5. Tạo 30 bản ghi cho bảng Answers
# Mỗi đáp án gán cho câu hỏi theo thứ tự (có đánh dấu đúng/sai xen kẽ)
questions = Question.order(:id)
30.times do |i|
  Answer.create!(
    question_id: questions[i % 30].id,
    body: "Đáp án #{i+1} cho câu hỏi #{questions[i % 30].id}",
    is_correct: (i % 2 == 0),
    image_url: "http://example.com/answer#{i+1}.png"
  )
end
puts "Tạo 30 bản ghi trong bảng Answers."

# 6. Tạo 30 bản ghi cho bảng QuizSettings (cho 30 user thường)
users.first(30).each do |user|
  QuizSetting.create!(
    user_id: user.id,
    difficulty: "medium",
    percen_complete: 100.0,
    total_quiz: 10,
    total_correct_answers: 7,
    question_max: "20",
    question_increase: 2
  )
end
puts "Tạo 30 bản ghi trong bảng QuizSettings."

# 7. Tạo 30 bản ghi cho bảng Quizzes
quiz_settings = QuizSetting.order(:id)
30.times do |i|
  Quiz.create!(
    title: "Quiz #{i+1}",
    quiz_setting_id: quiz_settings[i % 30].id,
    description: "Mô tả cho Quiz #{i+1}",
    category_id: categories[i % 30].id,
    difficulty: "medium",
    total_questions: 10,
    time_limit: 30,
    status: true
  )
end
puts "Tạo 30 bản ghi trong bảng Quizzes."

# 8. Tạo 30 bản ghi cho bảng QuizQuestions (liên kết giữa Quizzes và Questions)
quizzes = Quiz.order(:id)
30.times do |i|
  QuizQuestion.create!(
    quiz_id: quizzes[i % 30].id,
    question_id: questions[i % 30].id,
    position: i+1
  )
end
puts "Tạo 30 bản ghi trong bảng QuizQuestions."

# 9. Tạo 30 bản ghi cho bảng QuizResults
30.times do |i|
  QuizResult.create!(
    user_id: users[i % users.size].id,
    category_id: categories[i % 30].id,
    quiz_id: quizzes[i % 30].id,
    score: 80,
    correct_answers: 8,
    incorrect_answers: 2,
    start_time: Time.now,
    end_time: Time.now + 30.minutes,
    status: "completed"
  )
end
puts "Tạo 30 bản ghi trong bảng QuizResults."

# 10. Tạo 30 bản ghi cho bảng UserAnswers
answers = Answer.order(:id)
30.times do |i|
  UserAnswer.create!(
    user_id: users[i % users.size].id,
    quiz_id: quizzes[i % 30].id,
    question_id: questions[i % 30].id,
    answer_id: answers[i % 30].id,
    is_correct: (i % 2 == 0),
    category_id: categories[i % 30].id
  )
end
puts "Tạo 30 bản ghi trong bảng UserAnswers."

# 11. Tạo 30 bản ghi cho bảng AuthLogs
30.times do |i|
  AuthLog.create!(
    user_id: users[i % users.size].id,
    login_at: Time.now,
    ip_address: "192.168.1.#{i+1}",
    user_agent: "Mozilla/5.0 (Test Agent #{i+1})",
    status: "success",
    logout_at: Time.now + 1.hour
  )
end
puts "Tạo 30 bản ghi trong bảng AuthLogs."

# 12. Tạo 30 bản ghi cho bảng Charts
30.times do |i|
  Chart.create!(
    user_id: users[i % users.size].id,
    category_id: categories[i % 30].id,
    date: Time.now,
    quiz_taken: 5,
    correct_answers: 4,
    wrong_answers: 1,
    total_score: 80
  )
end
puts "Tạo 30 bản ghi trong bảng Charts."

# 13. Tạo 30 bản ghi cho bảng Favorites
30.times do |i|
  Favorite.create!(
    user_id: users[i % users.size].id,
    category_id: categories[i % 30].id
  )
end
puts "Tạo 30 bản ghi trong bảng Favorites."

# 14. Tạo 30 bản ghi cho bảng Follows (người dùng theo dõi nhau)
user_ids = users.pluck(:id)
30.times do |i|
  follower_id = user_ids[i % user_ids.size]
  followed_id = user_ids[(i+1) % user_ids.size]  # user tiếp theo trong danh sách
  Follow.create!(
    follower_id: follower_id,
    followed_id: followed_id
  )
end
puts "Tạo 30 bản ghi trong bảng Follows."

# 15. Tạo 30 bản ghi cho bảng LeaderBoards
30.times do |i|
  LeaderBoard.create!(
    user_id: users[i % users.size].id,
    score: (i+1) * 10,
    rank: i+1
  )
end
puts "Tạo 30 bản ghi trong bảng LeaderBoards."

# 16. Tạo 30 bản ghi cho bảng Notifications
30.times do |i|
  Notification.create!(
    user_id: users[i % users.size].id,
    message: "Thông báo số #{i+1}",
    notification_type: "info",
    status: false
  )
end
puts "Tạo 30 bản ghi trong bảng Notifications."

# 17. Tạo 30 bản ghi cho bảng PointHistories
30.times do |i|
  PointHistory.create!(
    user_id: users[i % users.size].id,
    point: i+1,
    reason: "Lý do thay đổi điểm #{i+1}",
    status: 0
  )
end
puts "Tạo 30 bản ghi trong bảng PointHistories."

# 18. Tạo 30 bản ghi cho bảng PointRules
30.times do |i|
  PointRule.create!(
    category_id: categories[i % 30].id,
    difficulty: "medium",
    point_awarded: 10
  )
end
puts "Tạo 30 bản ghi trong bảng PointRules."

# 19. Tạo 30 bản ghi cho bảng Points
30.times do |i|
  Point.create!(
    user_id: users[i % users.size].id,
    total_point: 100,
    level: 1
  )
end
puts "Tạo 30 bản ghi trong bảng Points."

# 20. Tạo 30 bản ghi cho bảng SortOrders
30.times do |i|
  SortOrder.create!(
    user_id: users[i % users.size].id,
    category_id: categories[i % 30].id,
    order: i+1
  )
end
puts "Tạo 30 bản ghi trong bảng SortOrders."

# 21. Tạo 30 bản ghi cho bảng Statistics
30.times do |i|
  Statistic.create!(
    user_id: users[i % users.size].id,
    category_id: categories[i % 30].id,
    total_correct_answers: 10,
    total_incorrect_answers: 2,
    date: Time.now
  )
end
puts "Tạo 30 bản ghi trong bảng Statistics."

# 22. Tạo 30 bản ghi cho bảng UnlockedLevels
30.times do |i|
  UnlockedLevel.create!(
    user_id: users[i % users.size].id,
    category_id: categories[i % 30].id,
    difficulty: "medium",
    unlock_date: Time.now,
    status: "unlocked",
    comleted_quiz: 5,
    required_quiz: 10
  )
end

#23. Tạo 5 bản ghi cho bảng LevelConfigs
LevelConfig.create!([
  { level: 1, name: "Tân binh", required_points: 0, quiz_reward: 10, login_reward: 5, status: true },
  { level: 2, name: "Người học", required_points: 100, quiz_reward: 15, login_reward: 7, status: true },
  { level: 3, name: "Học viên tích cực", required_points: 250, quiz_reward: 20, login_reward: 10, status: true },
  { level: 4, name: "Chuyên gia", required_points: 500, quiz_reward: 25, login_reward: 12, status: true },
  { level: 5, name: "Bậc thầy", required_points: 1000, quiz_reward: 30, login_reward: 15, status: true }
])

puts "Tạo 30 bản ghi trong bảng UnlockedLevels."

PointReward.create!([
  {
    name: "Voucher giảm giá 10%",
    description: "Áp dụng cho khóa học online",
    required_points: 50,
    quantity: 100,
    redeemed: 35,
    status: :available
  },
  {
    name: "Voucher giảm giá 20%",
    description: "Áp dụng cho khóa học online",
    required_points: 100,
    quantity: 50,
    redeemed: 22,
    status: :available
  },
  {
    name: "Mở khóa 1 quiz cao cấp",
    description: "Mở khóa quiz bất kỳ trong danh mục premium",
    required_points: 150,
    quantity: 200,
    redeemed: 78,
    status: :available
  },
  {
    name: "Tài liệu học tập PDF",
    description: "Bộ tài liệu học tập chuyên sâu",
    required_points: 200,
    quantity: 100,
    redeemed: 45,
    status: :available
  },
  {
    name: "Voucher giảm giá 50%",
    description: "Áp dụng cho một khóa học bất kỳ",
    required_points: 500,
    quantity: 20,
    redeemed: 8,
    status: :available
  },
  {
    name: "Khóa học miễn phí",
    description: "Một khóa học miễn phí bất kỳ",
    required_points: 1000,
    quantity: 10,
    redeemed: 2,
    status: :expired
  }
])

# Lấy user mẫu (giả sử có user ID từ 1 đến 5)
user_ids = User.pluck(:id)

# Seed các bản ghi đổi điểm
PointHistory.create!([
  {
    user_id: user_ids.sample,
    point: -100,
    reason: "Đổi thưởng: Voucher giảm giá 20%",
    status: 1,
    created_at: 3.days.ago
  },
  {
    user_id: user_ids.sample,
    point: -150,
    reason: "Đổi thưởng: Mở khóa 1 quiz cao cấp",
    status: 1,
    created_at: 2.days.ago
  },
  {
    user_id: user_ids.sample,
    point: -200,
    reason: "Đổi thưởng: Tài liệu học tập PDF",
    status: 1,
    created_at: 1.day.ago
  },
  {
    user_id: user_ids.sample,
    point: -50,
    reason: "Đổi thưởng: Voucher giảm giá 10%",
    status: 1,
    created_at: 6.hours.ago
  },
  {
    user_id: user_ids.sample,
    point: -500,
    reason: "Đổi thưởng: Voucher giảm giá 50%",
    status: 1,
    created_at: 2.hours.ago
  }
])

# Lấy sẵn danh sách users để gán user_id cho từng noti
users = User.limit(5)

Notification.create!(
  user_id: users[0].id,
  message: "Nguyễn Văn A đã đăng ký tài khoản mới",
  notification_type: "user_signup",
  status: false
)

Notification.create!(
  user_id: users[1].id,
  message: "Trần Thị B đã hoàn thành bài test 'Khoa học xã hội'",
  notification_type: "quiz_finish",
  status: false
)

Notification.create!(
  user_id: users[2].id,
  message: "Admin đã thêm 5 câu hỏi mới vào chủ đề 'Khoa học tự nhiên'",
  notification_type: "admin_action",
  status: false
)

Notification.create!(
  user_id: users[3].id,
  message: "Lê Văn C đã đạt điểm cao nhất trong chủ đề 'Khoa học tự nhiên'",
  notification_type: "high_score",
  status: false
)

Notification.create!(
  user_id: users[4].id,
  message: "Admin đã tạo chủ đề mới 'Lịch sử Việt Nam'",
  notification_type: "new_topic",
  status: false
)

puts "Tạo 5 bản ghi tùy chỉnh trong bảng Notifications."



puts "Seed dữ liệu hoàn tất!"
