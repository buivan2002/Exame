class Admin::ProfileController < Admin::ApplicationController
  def index
    @admin = current_user
  end
  def show
    @admin = current_user
  end

  def edit
    @admin = current_user
  end

  def update
    @admin = current_user
    if @admin.update(admin_params)
      redirect_to admin_profile_path, notice: "Profile updated successfully"
    else
      render :edit
    end
  end

  private

  def admin_params
    params.require(:user).permit(:name, :email, :phone)
  end
end
