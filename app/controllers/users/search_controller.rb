class Users::SearchController < ApplicationController
  include ElasticSearchHelper

  def elastic  
  @user=current_user
  users = search_users(params[:query])
  render json: users
  end
  

  def detail 
  user_id = current_user.id
  @user = search_users(params[:query])
  @followed_ids = Follow.where(follower_id: user_id).pluck(:followed_id)

  end
end
