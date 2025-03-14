class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def all_user_recent_log
    # Xử lý logic cho trang profile (ví dụ: lấy thông tin user)
    render template: 'admin/dashboard/all_user_recent_log'
  end
  def index
    @admin_user = User.find_by(role: 'admin')
    @users = User.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

end
