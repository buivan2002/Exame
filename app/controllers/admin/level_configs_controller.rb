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

  def destroy
    @level_config = LevelConfig.find(params[:id])
    @level_config.destroy
    respond_to do |format|
      format.html { redirect_to admin_points_path(anchor: "points-award"), notice: "Xoa cau hinh thanh cong" }
      format.json { render json: {success: true, message: "Xoa cau hinh thanh cong"}, status: :ok }
    rescue ActiveRecord::RecordNotFound
      format.html { redirect_to admin_points_path(anchor: "points-award"), notice: "Khong tim thay cau hinh" }
      format.json { render json: {success: false, message: "Khong tim thay cau hinh"}, status: :not_found }
    end
  end
  
  def update
    @level_config = LevelConfig.find(params[:id])
    if @level_config.update(level_config_params)
      redirect_to admin_points_path(anchor: "points-award"), notice: "Cập nhật thành công"
    else
      redirect_to admin_points_path(anchor: "points-award"), alert: "Cập nhật thất bại"
    end
  end

  private

  def level_config_params
    params.require(:level_config).permit(:level, :name, :required_points, :quiz_reward, :login_reward, :status)
  end
end
