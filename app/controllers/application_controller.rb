class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def after_sign_out_path_for(resource_or_scope)
    return root_path 
  end
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      root_path
    end
  end

end
