class Admin::DashboardController < Admin::ApplicationController
  def index
    @admin_user = User.find_by(role: 'admin')
    @stats = {
      total_users: User.count - 1,
      total_questions: Question.count,
      todays_quizzes: QuizResult.where(end_time: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count,
      total_categories: Category.count
    }
    # Lấy dữ liệu thống kê hàng tuần
    start_of_week = Date.today.beginning_of_week
    end_of_week   = Date.today.end_of_week
    @weekly_stats = Statistic.where(user_id: current_user.id, date: start_of_week..end_of_week)
                             .group("DATE(date)")
                             .select("DATE(date) as day, SUM(total_correct_answers) as total_correct, SUM(total_incorrect_answers) as total_incorrect")
                             .order("day ASC")

    respond_to do |format|
      format.html  # render view weekly_stats.html.erb
      # format.json { render json: @weekly_stats }
    end

    @topic_distribution = QuizResult.joins("INNER JOIN categories ON quiz_results.category_id = categories.id")
                                    .group("categories.name")
                                    .select("categories.name AS category_name, COUNT(quiz_results.id) AS quiz_count")
                                    .order("quiz_count DESC")

    respond_to do |format|
      format.html  # render view topic_distribution.html.erb
      # format.json { render json: @topic_distribution }
    end

    @recent_auth_logs = AuthLog.includes(:user).order(login_at: :desc).limit(5)


    @recent_logs = AuthLog.includes(:user).order(login_at: :desc).limit(4)
    @top_scores = QuizResult.joins(:user).select('quiz_results.*, users.name').order('quiz_results.score DESC').limit(4)

    @category_data = Category.joins(:questions).group('categories.name').count('questions.id')
  end
  def abc

  end

  private

end
