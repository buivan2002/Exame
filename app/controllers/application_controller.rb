class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # skip_before_action :authenticate_user!, only: [:home]
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # Chuyển hướng đến trang đăng nhập
  end
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      root_path
    end
  end

end
