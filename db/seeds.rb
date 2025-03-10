# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb
require 'faker'

puts "Cleaning up database..."

# Xóa dữ liệu theo thứ tự ngược lại với quan hệ (để tránh lỗi khóa ngoại)
UserAnswer.destroy_all
QuizQuestion.destroy_all
QuizResult.destroy_all
Quiz.destroy_all
QuizSetting.destroy_all
SortOrder.destroy_all
UnlockedLevel.destroy_all
Statistic.destroy_all
Point.destroy_all
PointRule.destroy_all
Notification.destroy_all
LeaderBoard.destroy_all
Follow.destroy_all
Favorite.destroy_all
Chart.destroy_all
PointHistory.destroy_all
AuthLog.destroy_all
Answer.destroy_all
Question.destroy_all
Category.destroy_all
User.destroy_all

puts "Database cleaned!"

# ---------------------------
# 1. Tạo Users
# ---------------------------
puts "Seeding Users..."
users = 5.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 'password',
    role: ['admin', 'user'].sample,
    last_login_at: Faker::Time.backward(days: 30),
    avatar_url: Faker::Avatar.image,
    oauth_provider: [nil, 'google', 'facebook'].sample,
    oauth_id: Faker::Internet.uuid
  )
end
puts "Seeded #{users.count} Users."

# ---------------------------
# 2. Tạo Categories
# ---------------------------
puts "Seeding Categories..."
categories = 3.times.map do
  Category.create!(
    name: Faker::Commerce.department(max: 1, fixed_amount: true),
    description: Faker::Lorem.sentence,
    status: ['active', 'inactive'].sample
  )
end
puts "Seeded #{categories.count} Categories."

# ---------------------------
# 3. Tạo Questions cho mỗi Category
# ---------------------------
puts "Seeding Questions..."
questions = []
categories.each do |category|
  3.times do
    questions << Question.create!(
      category: category,
      content: Faker::Lorem.sentence(word_count: 10),
      question_type: ['multiple_choice', 'true_false', 'short_answer'].sample,
      difficulty: ['easy', 'medium', 'hard'].sample,
      status: ['active', 'inactive'].sample,
      explanation: Faker::Lorem.sentence,
      image_url: Faker::LoremFlickr.image
    )
  end
end
puts "Seeded #{questions.count} Questions."

# ---------------------------
# 4. Tạo Answers cho mỗi Question
# ---------------------------
puts "Seeding Answers..."
answers = []
questions.each do |question|
  # Giả sử: câu trả lời đầu tiên của mỗi câu hỏi là đáp án đúng
  4.times do |i|
    answers << Answer.create!(
      question: question,
      body: Faker::Lorem.sentence,
      is_correct: i == 0,   # đáp án đầu tiên đúng
      image_url: Faker::LoremFlickr.image,
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded #{answers.count} Answers."

# ---------------------------
# 5. Tạo AuthLogs cho mỗi User
# ---------------------------
puts "Seeding AuthLogs..."
users.each do |user|
  2.times do
    AuthLog.create!(
      user: user,
      login_at: Faker::Time.backward(days: 10),
      ip_address: Faker::Internet.ip_v4_address,
      user_agent: Faker::Internet.user_agent,
      status: ['success', 'failure'].sample,
      logout_at: Faker::Time.backward(days: 5),
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded AuthLogs."

# ---------------------------
# 6. Tạo Charts cho mỗi kết hợp User - Category
# ---------------------------
puts "Seeding Charts..."
users.each do |user|
  categories.each do |category|
    Chart.create!(
      user: user,
      category: category,
      date: Faker::Time.backward(days: 7),
      quiz_taken: rand(1..10),
      correct_answers: rand(1..10),
      wrong_answers: rand(0..5),
      total_score: rand(10..100),
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded Charts."

# ---------------------------
# 7. Tạo Favorites (mỗi user chọn 1 category ngẫu nhiên)
# ---------------------------
puts "Seeding Favorites..."
users.each do |user|
  Favorite.create!(
    user: user,
    category: categories.sample,
    created_at: Time.now,
    updated_at: Time.now
  )
end
puts "Seeded Favorites."

# ---------------------------
# 8. Tạo Follows (mỗi cặp user khác nhau sẽ có mối quan hệ follow)
# ---------------------------
puts "Seeding Follows..."
users.combination(2).each do |follower, followed|
  Follow.create!(
    follower: follower,
    followed: followed,
    created_at: Time.now,
    updated_at: Time.now
  )
end
puts "Seeded Follows."

# ---------------------------
# 9. Tạo LeaderBoards cho mỗi User
# ---------------------------
puts "Seeding LeaderBoards..."
users.each do |user|
  LeaderBoard.create!(
    user: user,
    score: rand(50..200),
    rank: rand(1..users.count),
    created_at: Time.now,
    updated_at: Time.now
  )
end
puts "Seeded LeaderBoards."

# ---------------------------
# 10. Tạo Notifications cho mỗi User
# ---------------------------
puts "Seeding Notifications..."
users.each do |user|
  2.times do
    Notification.create!(
      user: user,
      message: Faker::Lorem.sentence,
      notification_type: ['info', 'warning', 'alert'].sample,
      status: [true, false].sample,
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded Notifications."

# ---------------------------
# 11. Tạo PointHistories cho mỗi User
# ---------------------------
puts "Seeding PointHistories..."
users.each do |user|
  3.times do
    PointHistory.create!(
      user: user,
      point: rand(1..10),
      reason: Faker::Lorem.sentence,
      status: [true, false].sample,
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded PointHistories."

# ---------------------------
# 12. Tạo PointRules cho mỗi Category theo từng độ khó
# ---------------------------
puts "Seeding PointRules..."
categories.each do |category|
  ['easy', 'medium', 'hard'].each do |difficulty|
    PointRule.create!(
      category: category,
      difficulty: difficulty,
      point_awarded: rand(1..10),
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded PointRules."

# ---------------------------
# 13. Tạo Points cho mỗi User
# ---------------------------
puts "Seeding Points..."
users.each do |user|
  Point.create!(
    user: user,
    total_point: rand(10..100),
    level: rand(1..5),
    created_at: Time.now,
    updated_at: Time.now
  )
end
puts "Seeded Points."

# ---------------------------
# 14. Tạo QuizSettings cho mỗi User
# ---------------------------
puts "Seeding QuizSettings..."
quiz_settings = users.map do |user|
  QuizSetting.create!(
    user: user,
    difficulty: ['easy', 'medium', 'hard'].sample,
    percen_complete: rand.round(2),
    total_quiz: rand(1..10),
    total_correct_answers: rand(1..10),
    question_max: "10",
    question_increase: rand(1..5),
    created_at: Time.now,
    updated_at: Time.now
  )
end
puts "Seeded QuizSettings."

# ---------------------------
# 15. Tạo Quizzes cho mỗi QuizSetting và Category
# ---------------------------
puts "Seeding Quizzes..."
quizzes = []
quiz_settings.each do |qs|
  categories.each do |category|
    quizzes << Quiz.create!(
      title: Faker::Lorem.sentence,
      quiz_setting: qs,
      description: Faker::Lorem.sentence,
      category: category,
      difficulty: qs.difficulty,
      total_questions: rand(5..15),
      time_limit: rand(30..120),
      status: [true, false].sample,
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded #{quizzes.count} Quizzes."

# ---------------------------
# 16. Tạo QuizQuestions (liên kết Quiz và Question)
# ---------------------------
puts "Seeding QuizQuestions..."
quizzes.each do |quiz|
  selected_questions = questions.sample(3)
  selected_questions.each_with_index do |question, index|
    QuizQuestion.create!(
      quiz: quiz,
      question: question,
      position: index + 1,
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded QuizQuestions."

# ---------------------------
# 17. Tạo QuizResults cho mỗi Quiz
# ---------------------------
puts "Seeding QuizResults..."
quizzes.each do |quiz|
  QuizResult.create!(
    user: users.sample,
    category: quiz.category,
    quiz: quiz,
    score: rand(0..100),
    correct_answers: rand(0..quiz.total_questions),
    incorrect_answers: rand(0..quiz.total_questions),
    start_time: Time.now - 3600,
    end_time: Time.now,
    status: 'completed',
    created_at: Time.now,
    updated_at: Time.now
  )
end
puts "Seeded QuizResults."

# ---------------------------
# 18. Tạo SortOrders cho mỗi User và Category
# ---------------------------
puts "Seeding SortOrders..."
users.each do |user|
  categories.each do |category|
    SortOrder.create!(
      user: user,
      category: category,
      order: rand(1..10),
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded SortOrders."

# ---------------------------
# 19. Tạo Statistics cho mỗi User và Category
# ---------------------------
puts "Seeding Statistics..."
users.each do |user|
  categories.each do |category|
    Statistic.create!(
      user: user,
      category: category,
      total_correct_answers: rand(0..50),
      total_incorrect_answers: rand(0..50),
      date: Time.now,
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded Statistics."

# ---------------------------
# 20. Tạo UnlockedLevels cho mỗi User và Category
# ---------------------------
puts "Seeding UnlockedLevels..."
users.each do |user|
  categories.each do |category|
    UnlockedLevel.create!(
      user: user,
      category: category,
      difficulty: ['easy', 'medium', 'hard'].sample,
      unlock_date: Time.now,
      status: ['unlocked', 'locked'].sample,
      comleted_quiz: rand(0..5),
      required_quiz: rand(1..10),
      created_at: Time.now,
      updated_at: Time.now
    )
  end
end
puts "Seeded UnlockedLevels."

# ---------------------------
# 21. Tạo UserAnswers cho mỗi User và Quiz
# ---------------------------
puts "Seeding UserAnswers..."
quizzes.each do |quiz|
  quiz.quiz_questions.each do |qq|
    users.each do |user|
      possible_answers = Answer.where(question: qq.question)
      selected_answer = possible_answers.sample
      UserAnswer.create!(
        user: user,
        quiz: quiz,
        question: qq.question,
        answer: selected_answer,
        is_correct: selected_answer.is_correct,
        category: qq.question.category,
        created_at: Time.now,
        updated_at: Time.now
      )
    end
  end
end
puts "Seeded UserAnswers."

puts "Database seeding completed!"
