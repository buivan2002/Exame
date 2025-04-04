class Admin::CategoriesController < Admin::ApplicationController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.order(created_at: :desc).page(params[:page]).per(100)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: 'Category was successfully destroyed.'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :status)
  end
end
