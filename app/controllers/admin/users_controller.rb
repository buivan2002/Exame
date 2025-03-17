class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

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
      Category.order(:id).each_with_index do |category, index|
        SortOrder.create(
          user_id: @user.id,
          category_id: category.id,
          order: index + 1
        )
      end

      QuizSetting.create(
        user_id: @user.id,
        difficulty: "easy",
        percen_complete: 0,
        total_quiz: 0,
        total_correct_answers: 0,
        question_max: 5,
        question_increase: 5
      )

      Point.create(
        user_id: @user.id,
        total_point: 0,
        level: 1
      )

      Category.where(status: "active").each do |category|
        UnlockedLevel.create(
          user_id: @user.id,
          category_id: category.id,
          difficulty: "easy",
          unlock_date: @user.created_at,
          status: "active",
          comleted_quiz: 0,
          required_quiz: 5
        )
      end

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
