class Admin::LevelConfigsController < Admin::ApplicationController
  def create
    @level_config = LevelConfig.new(level_config_params)

    respond_to do |format|
      if @level_config.save
        format.html { redirect_to admin_points_path(anchor: "points-award"), notice: "Tao cau hinh thanh cong"}
        format.json { render json: {success: true, message: "Tao cau hinh thanh cong"}, status: :created }
      else
        format.html {
          flash[:error] = "Khong the tao cau hinh"
          redirect_to admin_points_path(anchor: "points-award")
        }
        format.json { render json: {success: false, errors: @level_config.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  private

  def level_config_params
    params.require(:level_config).permit(:level, :name, :required_points, :quiz_reward, :login_reward, :status)
  end
end
