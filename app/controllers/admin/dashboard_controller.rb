module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    def index
    end

    private

    def check_admin
      redirect_to root_path, alert: "Bạn không có quyền truy cập!" unless current_user.role == "admin"
    end
  end
end
