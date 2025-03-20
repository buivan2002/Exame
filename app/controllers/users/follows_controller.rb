class Users::FollowsController < ApplicationController
  def unfollow
    follow = Follow.find_by(id: params[:id])
    follow.destroy if follow
    head :no_content
  end
  def remove_follower
    follow = Follow.find_by(id: params[:id])
    follow.destroy if follow
    head :no_content
  end
  def unfollow_serach
  follow = Follow.find_by(follower_id: current_user.id, followed_id: params[:id])
  follow.destroy if follow
  head :no_content
    
  end
  def follow
   Follow.create!(follower_id: current_user.id, followed_id: params[:id])
   head :no_content

  end
end 