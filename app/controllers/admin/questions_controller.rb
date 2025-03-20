class Admin::QuestionsController < Admin::ApplicationController
  before_action :set_question, only: %i[show edit update destroy]
  def index
    @questions = Question.includes(:category)
                         .where('content LIKE ?', "%#{params[:search]}%")
                         .order(created_at: :desc)

    if params[:question_type] && params[:question_type] != 'all'
      @questions = @questions.where(question_type: params[:question_type])
    end

    @questions = @questions.page(params[:page]).per(10)
  end

  def new
    @question = Question.new
    2.times { @question.answers.build }
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to admin_questions_path, notice: "Câu hỏi đã được tạo thành công."
    else
      render :new
    end
  end

  def show
    @question = Question.includes(:category, :answers).find(params[:id])
  end

  def edit; end

  def update
    if @question.update(question_params)
      redirect_to admin_questions_path, notice: 'Câu hỏi và đáp án đã được cập nhật thành công.'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_questions_path, notice: 'Câu hỏi đã được xóa.'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :category_id,
      :content,
      :question_type,
      :difficulty,
      :status,
      :explanation,
      :image_url,
      answers_attributes: [:id, :body, :is_correct, :image_url, :_destroy]
    )
  end

end
