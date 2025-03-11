class Admin::DashboardController < Admin::BaseController
  before_action :authenticate_user!
  before_action :check_admin
  layout "admin"
  def index
    # Lấy thông tin tổng quan cho dashboard
    @stats = {
      total_users: User.count,
      total_questions: Question.count,
      todays_quizzes: QuizResult.where("DATE(end_time) = ?", Date.today).count,
      total_categories: Category.count
    }

    @admin_user = User.find_by(role: 'admin')
    @recent_logs = AuthLog.includes(:user).order(login_at: :desc).limit(4)
    @top_scores = QuizResult.joins(:user).select('quiz_results.*, users.name').order('quiz_results.score DESC').limit(4)

    @category_data = Category.joins(:questions).group('categories.name').count('questions.id')
  end

  private

  def check_admin
    redirect_to root_path, alert: "Bạn không có quyền truy cập!" unless current_user.role == "admin"
  end
end
