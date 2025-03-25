class Admin::HistoriesController < Admin::ApplicationController
  def index
    @users = User.where(role:"user")
    @quiz_results = QuizResult.all()
    @quiz_score = QuizResult.all.order(score: :desc)
    @total_user = User.where(last_login_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
    @quiz_comple = QuizResult.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
    @quiz_hightscore = QuizResult.where(
      "created_at BETWEEN ? AND ? AND score > ?", 
      Time.zone.now.beginning_of_month, 
      Time.zone.now.end_of_month, 
      50
    )
    filter = params[:filter] || "all"

    case filter
    when "today"
      @users  = User.where("last_login_at >= ?", Time.zone.today.beginning_of_day)
    when "week"
      @users = User.where("last_login_at >= ?", Time.zone.today.beginning_of_week)
    when "month"
      @users = User.where("last_login_at >= ?", Time.zone.today.beginning_of_month)
    else
      @users = User.all
    end    
  end
end
