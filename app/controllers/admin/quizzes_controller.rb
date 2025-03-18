class Admin::QuizzesController < Admin::ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  def index
    @quizzes = Quiz.includes(:questions).order(created_at: :desc)
    # Thống kê số lượng
    @total_quizzes = @quizzes.count
    @total_questions = Question.count
    @total_attempts = QuizResult.count
    @completion_rate = if QuizResult.count > 0
                          (QuizResult.where(status: "completed").count.to_f / QuizResult.count * 100).round(2)
                        else
                          0
                        end
  end

  def new

  end

  def create
  end

  def show
    @quiz_setting = @quiz.quiz_setting
    @quiz_questions = @quiz.quiz_questions.includes(question: :answers).order(:position)
  end

  def edit
    begin
      if true
        raise "Không thể sửa quiz do quiz được tạo tự động."
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Quiz không tồn tại."
      redirect_to admin_quizzes_path
    rescue => e
      flash[:error] = e.message
      redirect_to admin_quizzes_path
    end
  end

  def update
  end

  def destroy
    if @quiz.destroy
      flash[:notice] = "Bài quiz đã được xóa thành công."
    else
      flash[:alert] = "Có lỗi xảy ra khi xóa bài quiz."
    end
    redirect_to admin_quizzes_path
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Bài quiz không tồn tại."
    redirect_to admin_quizzes_path
  end
end
