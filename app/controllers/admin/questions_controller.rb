class Admin::QuestionsController < Admin::ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    # Sử dụng phân trang (giả sử gem kaminari hoặc will_paginate đã được cài)
    # Sắp xếp theo ngày tạo mới nhất
    # @questions = Question.order(created_at: :desc).page(params[:page]).per(5)
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
    # Có thể hiển thị chi tiết câu hỏi, ví dụ như danh sách câu trả lời nếu cần
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to admin_questions_path, notice: "Câu hỏi được cập nhật thành công."
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
    params.require(:question).permit(:content, :category, :status)
  end
end
