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
  def questions
    @category = Category.find(params[:id])
    difficulty = params[:difficulty]
    
    # Lấy ngẫu nhiên 10 câu hỏi từ quizz_settings theo danh mục & độ khó
    @questions = QuizzSetting.where(category_id: @category.id, difficulty: difficulty).order("RAND()").limit(10)
  
    if @questions.empty?
      redirect_to difficulty_users_category_path(@category), alert: "Không có câu hỏi nào phù hợp!"
    end
  end
  
end
