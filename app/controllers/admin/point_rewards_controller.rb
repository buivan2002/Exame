class Admin::PointRewardsController < Admin::ApplicationController
  def create
    @point_reward = PointReward.new(point_reward_params)

    if @point_reward.save
      redirect_to admin_points_path(anchor: "points-exchange"), notice: "Thêm phần thưởng thành công!"
    else
      redirect_to admin_points_path(anchor: "points-exchange"), alert: "Thêm phần thưởng thất bại!"
    end
  end

  def edit
    @point_reward = PointReward.find(params[:id])
  end

  def update
    @point_reward = PointReward.find(params[:id])
    if @point_reward.update(point_reward_params)
      redirect_to admin_points_path(anchor: "points-exchange"), notice: "Cập nhật phần thưởng thành công."
    else
      redirect_to :edit, alert: "Có lỗi khi cập nhật phần thưởng."
    end
  end
  def destroy
    @point_reward = PointReward.find(params[:id])
    @point_reward.destroy
    redirect_to admin_points_path(anchor: "points-exchange"), notice: "Xóa phần thưởng thành công."
  end


  private

  def point_reward_params
    params.require(:point_reward).permit(:name, :description, :required_points, :quantity, :status)
  end
end
