class CreateQuizJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 3  # Chỉ retry tối đa 3 lần

  def perform(user_id, quiz_setting_id, category_id, difficulty, question_ids,user_answers,correct_answers)
    user = User.find(user_id)
    quiz_setting = QuizSetting.find_by(user_id: user_id)
    question_count = question_ids.size

    category = Category.find(category_id)
    # ✅ Tạo quiz
    quiz = Quiz.create!(
      title: "Bài thi của #{user.email}",
      quiz_setting: quiz_setting,
      category: category,
      difficulty: difficulty,
      total_questions: question_count,
      time_limit: 30,
      status: :active
    )
    # ✅ Bulk insert QuizQuestion để tối ưu hiệu suất
    quiz_questions = question_ids.each_with_index.map do |question_id, index|
      { quiz_id: quiz.id, question_id: question_id, position: index + 1, created_at: Time.now, updated_at: Time.now }
     # quiz.quiz_questions.create!(question_id: question_id, position: index + 1) dùng cách này cũng được nó đúng với cái associations

    end
    QuizQuestion.insert_all(quiz_questions)
    # Lưu user_answers
    score = 0
    correct_count = 0
    incorrect_count = 0

    user_answers.each do |question_id, user_answer|
      correct = correct_answers[question_id.to_s]&.map(&:id) || []   # check định dạng để tìm cho đúng 
      
      correct.map!(&:to_s)  # chuyển vê để cùng định dạng - cái map nó trả về kiểu integer 
      is_correct = user_answer.compact.sort == correct.sort  # Dùng compact để loại bỏ nil trước khi so sánh

      score += 1 if is_correct
      correct_count += 1 if is_correct
      incorrect_count += 1 unless is_correct
      user_answer = user_answer.compact.presence || [-1]  
      # presence
      # Kiểm tra nếu mảng sau khi compact vẫn rỗng ([]), sẽ trả về nil.
      # || [-1]
      # Nếu presence trả về nil, sẽ gán user_answer = [-1] để đảm bảo không có lỗi khi sử dụng.
      # Lưu câu trả lời của user
      user_answer.each do |answer_id|
        quiz.user_answers.create!(
          user_id: user_id,
          question_id: question_id.to_i,
          answer_id: answer_id.to_i,  # Luôn có giá trị hợp lệ
          is_correct: correct.include?(answer_id.to_s),  # Kiểm tra chính xác
          category_id: category_id
        )
      end
    end
    # binding.pry
    # ✅ Gọi hàm lưu kết quả quiz
    save_quiz_result(user_id, category_id, quiz, score, correct_count, incorrect_count)
    # gọi hàm update staticst
    update_statistics(user_id, category_id, correct_count, incorrect_count)

    leaderboard = LeaderBoard.find_or_create_by(user_id: user.id)
    leaderboard.increment!(:score, score) #increment!: Tăng giá trị của một cột lên một số cụ thể.
    # Cập nhật rank
    update_rankings
    # cap nhat quizsetting
    quizz_setting(user_id, correct_count, incorrect_count,quiz_setting)
  end

  private
  # 📌 Hàm riêng để lưu kết quả vào bảng quiz_results
  def save_quiz_result(user_id, category_id, quiz, score, correct_count, incorrect_count)
    QuizResult.create!(
      user_id: user_id,
      category_id: category_id,
      quiz_id: quiz.id,
      score: score,
      correct_answers: correct_count,
      incorrect_answers: incorrect_count,
      start_time: Time.zone.now,
      end_time: Time.zone.now + quiz.time_limit.minutes,
      status: "completed"
    )

    Rails.logger.info "✅ QuizResult created for User ##{user_id}, Score: #{score}"
  end
  def update_rankings
    LeaderBoard.order(score: :desc).each_with_index do |lb, index| #Lấy tất cả người chơi, sắp xếp theo total_score từ cao xuống thấp.
      lb.update_column(:rank, index + 1) # Tránh gọi callback để tối ưu hiệu suất
      
    end
    Rails.logger.info "✅ okee r  Score: "
  end
  def update_statistics(user_id, category_id, correct_answers, incorrect_answers)
    # Lấy ngày hiện tại
    today = Time.now
    # Tìm hoặc tạo mới bản ghi thống kê của user trong ngày
    statistics = Statistic.find_by(user_id: user_id, category_id: category_id)
    # Cộng dồn dữ liệu
    statistics.date = today
    statistics.category_id = category_id
    statistics.total_correct_answers += correct_answers
    statistics.total_incorrect_answers += incorrect_answers
    # Lưu vào database
    statistics.save!
    Rails.logger.info "✅ : update_statistics okii "
  end
  def quizz_setting(user_id, correct_count, incorrect_count,quizz_setting)
  # Cập nhật tổng số bài quiz đã làm
  quizz_setting.total_quiz += 1
  # Cập nhật tổng số câu đúng và câu sai
  quizz_setting.total_correct_answers = correct_count
  # Tính phần trăm hoàn thành
  total_answers = correct_count + incorrect_count
  quizz_setting.percen_complete = total_answers.positive? ? quizz_setting.total_correct_answers.to_f / total_answers : 0
  # Nếu tỷ lệ đúng >= 50% thì tăng question_max
  if quizz_setting.percen_complete >= 0.5
    quizz_setting.question_max += quizz_setting.question_increase
  end
  quizz_setting.save!
  Rails.logger.info "✅ quizz_setting okii "
  end

end