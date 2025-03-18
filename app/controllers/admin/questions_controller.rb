class Admin::QuestionsController < Admin::ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    # Ví dụ filter đơn giản
    @questions = Question.all
    @questions = @questions.where("content LIKE ?", "%#{params[:search]}%") if params[:search].present?
    @questions = @questions.where(question_type: params[:question_type]) if params[:question_type].present? && params[:question_type] != 'all'

    # Sử dụng kaminari để phân trang
    @questions = @questions.page(params[:page]).per(10)
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to admin_questions_path, notice: "Câu hỏi được tạo thành công."
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
    # Nếu có quan hệ has_many :answers, @question.answers sẽ tự động được load
  end

  def edit
    # Với true_false, đảm bảo có 2 đáp án mặc định nếu chưa có
    if @question.question_type == "true_false"
      if @question.answers.size != 2
        @question.answers.destroy_all
        @question.answers.build(body: "Đúng", is_correct: true)
        @question.answers.build(body: "Sai", is_correct: false)
      end
    end
  end

  def update
    # Nếu kiểu câu hỏi là one_choice, ta có thể chuyển param correct_answer_id
    if @question.question_type == "one_choice" && params[:question][:correct_answer_id].present?
      correct_id = params[:question][:correct_answer_id].to_i
      @question.answers.each do |ans|
        ans.is_correct = (ans.id == correct_id)
      end
    end

    if @question.update(question_params)
      # Xử lý xóa ảnh nếu có checkbox đánh dấu (cho câu hỏi)
      if params[:remove_question_images].present?
        params[:remove_question_images].each do |img_id|
          img = @question.images.find(img_id)
          img.purge if img.present?
        end
      end

      # Xử lý xóa ảnh của đáp án (nếu có)
      if params[:remove_answer_images].present?
        params[:remove_answer_images].each do |index, img_ids|
          answer = @question.answers[index.to_i] rescue nil
          if answer.present?
            img_ids.each do |img_id|
              img = answer.images.find(img_id)
              img.purge if img.present?
            end
          end
        end
      end

      redirect_to admin_question_path(@question), notice: "Câu hỏi đã được cập nhật thành công!"
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_questions_path, notice: "Câu hỏi đã được xóa."
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
      :status,
      :explanation,
      :image_url, # nếu bạn vẫn sử dụng cột này, nhưng nếu dùng ActiveStorage thì trường này không cần
      images: [],
      answers_attributes: [:id, :body, :is_correct, :_destroy, :image_url, images: []]
    )
  end
end
