class Users::NotificationsController < ApplicationController
  def mark_as_read
    puts "chạy vào đây "

    notification = Notification.find(params[:id])
    notification.update(status: true)
    head :ok  
  end
end
