class Admin::PointsController < Admin::ApplicationController
  def index
    @total_points = Point.sum(:total_point)
    @users_with_points = Point.select(:user_id).distinct.count
    @total_points_last_30_days = PointHistory.where("created_at >= ? AND  point > 0", Time.zone.now - 30.days).sum(:point)
    @total_points_redeemed_last_30_days = PointHistory.where("created_at >= ? AND point < 0", Time.zone.now - 30.days).sum(:point)
    @point_histories = PointHistory
    .joins("LEFT JOIN users ON users.id = point_histories.user_id")
    .joins("LEFT JOIN points ON points.user_id = point_histories.user_id")
    .select(
      'point_histories.*',
      'users.name AS user_name',
      'points.total_point',
      'points.level'
    )
    .order('point_histories.created_at DESC')

    @level_configs = LevelConfig.order(:level)
    @level_config = LevelConfig.find(2)

    @point_rewards = PointReward.order(:id)
    @point_reward = PointReward.new
  end
end
