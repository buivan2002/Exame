class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :check_admin

  private

  def check_admin
    redirect_to root_path, alert: "Ban khong co quyen truy cap!" unless current_user.admin?
  end
end
