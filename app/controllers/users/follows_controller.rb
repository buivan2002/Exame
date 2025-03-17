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
  
end