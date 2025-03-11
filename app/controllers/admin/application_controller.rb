module Admin
  class ApplicationController < ::ApplicationController
    layout "admin"  # Dùng layout admin.html.erb
    before_action :authenticate_admin!

    private

    def authenticate_admin!
      redirect_to root_path unless current_user.admin?
    end
  end
end
