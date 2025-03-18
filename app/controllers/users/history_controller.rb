class Users::HistoryController < ApplicationController
  def index
    @user = current_user # Lấy thông tin người dùng đang đăng nhập
    @quiz_results = @user.quiz_results.includes(:category).order(created_at: :desc)
    render "users/history/index"
  end
  
  def detail
    @user = current_user # Lấy thông tin người dùng đang đăng nhập
    @quiz_result = QuizResult.includes(:quiz).find(params[:id]) 
    # Lấy danh sách câu trả lời của người dùng cho quiz này
    # @user_answers = UserAnswer.includes(:question, :answer).where(quiz_id: @quiz_result.quiz_id) # cách viết này lạ quá lọc ra rồi 
    @user_answers = UserAnswer.includes(question: :answers).where(quiz_id: @quiz_result.quiz_id)  
    # Lấy tất cả bản ghi từ UserAnswer.
    # Lấy tất cả Question có id trùng với question_id trong UserAnswer.
    # Lấy tất cả Answer có id trùng với answer_id trong UserAnswer.
    # Lưu dữ liệu vào bộ nhớ cache, khi gọi .question hoặc .answer trong mỗi UserAnswer, Rails không cần truy vấn lại DB.
    # binding.pry

    render "users/history/detail"

  end

end 