class Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    sign_out(resource)
    flash[:notice] = "Đăng ký thành công! Vui lòng đăng nhập để tiếp tục."
    new_user_session_path
  end
end
