class Users::CategoriesController < ApplicationController
  def index
    @categories = Category.where(status: "active") # Chỉ lấy danh mục active
  end

  def show
    @category = Category.find(params[:id])
  end
  def difficulty
    @category = Category.find(params[:id])
    # @difficulties = QuizSetting.distinct.pluck(:difficulty)
    @difficulties = ["easy", "medium", "hard"]
    @difficultOFuser = current_user.unlocked_levels.find_by(category_id: params[:id])&.difficulty
    UnlockedLevelsJob.perform_later(current_user.id) # lấy từng chủ đề và tăng độ khó lên nếu làm đủ yêu cầu 
    session[:user_answers] ||= {}
  end
  def question
    Rails.logger.info "Initializing session[:user_answers]: #{session[:user_answers]}"
    @category = Category.find(params[:id])  # lấy chủ đề
    @difficulty = params[:difficulty] # lấy độ khó
    @question_index = params[:question_index].to_i  #lấy index trên url
    # Lấy danh sách câu hỏi theo độ khó và lưu vào session nếu chưa có
    @quizzSetting = QuizSetting.select(:id, :question_max).find_by(user_id: current_user.id)
    # Lấy câu hỏi theo index
    # Kiểm tra nếu `session[:question_ids]` chưa có thì lấy từ `fetch_questions`
    unless session[:question_ids]
      session[:question_ids] = fetch_questions(@category.id, @difficulty, @quizzSetting.question_max).map(&:id)
    end
    # Lấy danh sách câu hỏi theo thứ tự đã lưu trong session
    @questions = Question.where(id: session[:question_ids])
                        .sort_by { |q| session[:question_ids].index(q.id) }
    # Chọn câu hỏi theo index
    @question = @questions[@question_index]
    if @question.nil?
      redirect_to root_path, alert: "Không có câu hỏi nào!" and return
    end
    session[:user_answers][@question.id.to_s] ||= [] # Đảm bảo mỗi câu hỏi luôn có một array
    # Lấy danh sách câu trả lời của câu hỏi hiện tại
    @answers = Answer.where(question_id: @question.id)
    unless session[:exam_start_time]
      # session[:exam_start_time] = Time.current.to_s  # Lưu dưới dạng string
      session[:exam_start_time] = Time.now
    end
    @time_left = ((session[:exam_start_time].to_time  + 1.minutes) - Time.now).to_i
end

  def submit_answer
    @user = current_user # Người dùng đang làm bài
    @category = Category.find(params[:id])
    @difficulty = params[:difficulty]
    @quizzSetting = QuizSetting.find_by(user_id: current_user.id) # Bỏ select(:id, :question_max)
    @question_index = params[:question_index].to_i
    @questions = Question.where(id: session[:question_ids])
    @questions = @questions.sort_by { |q| session[:question_ids].index(q.id) } # sắp xếp lại để nó đúng thứ tự trong session
    @question = @questions[@question_index]
    # Xóa câu trả lời cũ (nếu có) trước khi lưu cái mới
    session[:user_answers].delete(@question.id.to_s)
    # Kiểm tra loại câu hỏi để lưu đúng định dạng
    answer_values = case @question.question_type
    when "multiple_choice"
      params[:answers] || [] # Chọn nhiều đáp án -> mảng
    else
      [params[:answer_id]] || [] # Chọn 1 đáp án -> mảng có 1 phần tử
    end
    Rails.logger.info "BEFORE saving answer: #{session[:question_ids]}"
    session[:user_answers][@question.id.to_s] = answer_values    # luu dap an vao sesssion
    Rails.logger.info "AFTER saving answer: #{session[:question_ids]}"
    Rails.logger.info "Saving answer for question_id: #{@question.id}, available questions: #{session[:question_ids]}"
        # lưu đáp án của người dùng theo từng câu hỏi quizinutes) - Time.now).to_i
     @time_left = ((session[:exam_start_time].to_time  + 1.minutes) - Time.now).to_i
    if @time_left <= 0
      params[:submit_exam] = true
    end
    # Chuyển hướng đến câu tiếp theo hoặc trang kết quả
    if params[:next]
      redirect_to users_question_path(@category.id, @difficulty, @question_index + 1)
    elsif params[:prev]
      redirect_to users_question_path(@category.id, @difficulty, @question_index - 1)
    elsif params[:submit_exam]
      @correct_answers = Answer.where(question_id: session[:question_ids], is_correct: true) # lấy đáp án đúng của từng câu hỏi
      .group_by(&:question_id)
      @total_questions = @questions.count
          user_answers = session[:user_answers]
          question_ids = session[:question_ids]
          user_id = current_user.id
          quiz_setting_id = @quizzSetting.id
          category_id = @category.id
          difficulty = @difficulty
          notices = []
          @user.followers.each do |follower|
            notices << {
              user_id: follower.follower_id,
              message: "#{@user.email} vừa hoàn thành bài kiểm tra!",
              notification_type: "quiz",
              status: false
            }
          end
          Notification.create(notices)          
          CreateQuizJob.perform_later(user_id, quiz_setting_id, category_id, difficulty, question_ids,user_answers,  @correct_answers.transform_keys(&:to_s))
          PoinJob.perform_later(user_id,category_id,difficulty)
          session.delete(:user_answers)
          session.delete(:question_ids)
          session.delete(:exam_start_time)
          redirect_to  root_path
        end
    end
  
  private
  def fetch_questions(category_id, difficulty, question_max)
    question_max = question_max.to_i

    # Định nghĩa luật phân bố câu hỏi dựa trên số câu tối đa của người dùng
    distribution = {
      10 => { "easy" => [10, 0, 0], "medium" => [4, 6, 0], "hard" => [1, 3, 6] },
      15 => { "easy" => [15, 0, 0], "medium" => [6, 9, 0], "hard" => [2, 4, 9] },
      50 => { "easy" => [20, 0, 0], "medium" => [8, 12, 0], "hard" => [2, 6, 12] }
    }
    puts "diffi #{difficulty}"
    puts "ques_max #{question_max}"
    puts "class of question_max: #{question_max.class}" # Kiểm tra kiểu dữ liệu

    # Lấy số câu hỏi cần lấy theo mức độ khó hiện tại
    return [] unless distribution[question_max] && distribution[question_max][difficulty]
    puts "  - Số câu hỏi lấy ra: #{distribution[question_max]}"

    easy_count, medium_count, hard_count = distribution[question_max][difficulty]
    puts "socau #{easy_count}, #{medium_count},#{hard_count}"

    # Lấy câu hỏi từ DB theo luật phân bổ
    questions = []
    questions += Question.where(category_id: category_id, difficulty: "easy").order(Arel.sql("RAND()")).limit(easy_count)
    questions += Question.where(category_id: category_id, difficulty: "medium").order(Arel.sql("RAND()")).limit(medium_count)
    questions += Question.where(category_id: category_id, difficulty: "hard").order(Arel.sql("RAND()")).limit(hard_count)
    # puts "questions #{questions[]}"
    return questions
  end
end
