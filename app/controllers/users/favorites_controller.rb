class Users::FavoritesController < ApplicationController  
  def toggle
    category = Category.find(params[:category_id])
    favorite = current_user.favorites.find_by(category: category)
    if favorite
      favorite.destroy
      render json: { favorited: false }
    else
      current_user.favorites.create(category: category)
      render json: { favorited: true }
    end
  end
end
