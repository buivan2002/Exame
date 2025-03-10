class Users::CategoriesController < ApplicationController
  def index
    @categories = Category.where(status: "active") # Chỉ lấy danh mục active
  end

  def show
    @category = Category.find(params[:id])
  end

  def difficulty
    @category = Category.find(params[:id])
    @difficulties = QuizSetting.distinct.pluck(:difficulty)
  end

  def question
    @category = Category.find(params[:id])
    @difficulty = params[:difficulty]
    @question_index = params[:question_index].to_i
    # Lấy danh sách câu hỏi theo độ khó và lưu vào session nếu chưa có
    session[:question_ids] = fetch_questions(@category.id, @difficulty).map(&:id)

    
    # Lấy câu hỏi theo index
    @questions = Question.where(id: session[:question_ids])
    @question = @questions[@question_index]
    if @question.nil?
      redirect_to root_path, alert: "Không có câu hỏi nào!" and return
    end
  
    # Lấy danh sách câu trả lời của câu hỏi hiện tại
    @answers = Answer.where(question_id: @question.id)
    # session[:user_answers] ||= {} # Khởi tạo session[:user_answers] nếu nó chưa có
    session[:user_answers] ||= {}

  end
  
  
  
  
  
  def submit_answer
    @category = Category.find(params[:id])
    @difficulty = params[:difficulty]
    @question_index = params[:question_index].to_i
    @questions = Question.where(id: session[:question_ids])
    @question = @questions[@question_index]
    session[:user_answers] ||= {} 
    # Xóa câu trả lời cũ (nếu có) trước khi lưu cái mới
    session[:user_answers].delete(@question.id.to_s)
    
    # Kiểm tra loại câu hỏi để lưu đúng định dạng
    answer_values = case @question.question_type
    when "multiple_choice"
      params[:answers] || [] # Chọn nhiều đáp án -> mảng
    else
      [params[:answer_id]] || [] # Chọn 1 đáp án -> mảng có 1 phần tử
    end
    
    session[:user_answers][@question.id.to_s] = answer_values
    # binding.pry
                  
    # Chuyển hướng đến câu tiếp theo hoặc trang kết quả
    if params[:next]
      redirect_to users_question_path(@category.id, @difficulty, @question_index + 1)
    elsif params[:prev]
      redirect_to users_question_path(@category.id, @difficulty, @question_index - 1)
    else
      redirect_to root_path
    end
  end
  
  
  private

  def fetch_questions(category_id, difficulty)
    case difficulty
      
    when "easy"
      Question.where(category_id: category_id, difficulty: "easy").order(Arel.sql("RAND()")).limit(10)
    when "medium"
      Question.where(category_id: category_id, difficulty: "medium").order(Arel.sql("RAND()")).limit(6) +
        Question.where(category_id: category_id, difficulty: "easy").order(Arel.sql("RAND()")).limit(4)
    when "hard"
      Question.where(category_id: category_id, difficulty: "hard").order(Arel.sql("RAND()")).limit(6) +
        Question.where(category_id: category_id, difficulty: "medium").order(Arel.sql("RAND()")).limit(3) +
        Question.where(category_id: category_id, difficulty: "easy").order(Arel.sql("RAND()")).limit(1)
    else
      puts "không chạy 3 cái trên"
    end
  end
end
