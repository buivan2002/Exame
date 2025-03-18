class Users::ProfileController < ApplicationController
  def show 
    @categories = Category.where(status: "active") # Chỉ lấy danh mục active
    @user = current_user # Lấy thông tin người dùng đang đăng nhập
    # Số người đang follow (người dùng đang follow ai)
    @following = Follow.where(follower_id: @user.id)
    @following_count = @following.count

    # Số người theo dõi (ai đang follow người dùng này)
    @followers = Follow.where(followed_id: @user.id)
    @followers_count = @followers.count
    @points = @user.point
    render "users/profile/index"
  end
  def rank_score
    @leaderboard = LeaderBoard.order(score: :desc).limit(10)
    render "users/profile/rank_score"
  end

  def statistics
    @categories = Category.where(status: "active") # Chỉ lấy danh mục active
    render "users/profile/statistics"
  end
  def detail_statistics
    @user = current_user # Lấy thông tin người dùng đang đăng nhập
    @category = Category.find(params[:id])
    @statistic = @user.statistics.find_by(category: @category)
    render "users/profile/detail_statistics"
  end
end 