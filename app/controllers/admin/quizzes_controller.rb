# app/controllers/admin/quizzes_controller.rb
class Admin::QuizzesController < ApplicationController
  layout "admin"
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  def index
    # Sử dụng phân trang (giả sử gem kaminari hoặc will_paginate đã được cài)
    # Sắp xếp theo ngày tạo mới nhất
    # @quizzes = Quiz.order(created_at: :desc).page(params[:page]).per(5)
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      redirect_to admin_quizzes_path, notice: "Quiz được tạo thành công."
    else
      render :new
    end
  end

  def show
    # Có thể hiển thị chi tiết quiz, ví dụ như danh sách câu hỏi nếu cần
  end

  def edit
  end

  def update
    if @quiz.update(quiz_params)
      redirect_to admin_quizzes_path, notice: "Quiz được cập nhật thành công."
    else
      render :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to admin_quizzes_path, notice: "Quiz đã được xóa."
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    # Giả sử bảng quizzes có các trường: title, category, description, status
    params.require(:quiz).permit(:title, :category, :description, :status)
  end
end
