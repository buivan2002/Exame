# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
  def after_resetting_password_path_for(resource)
    root_path # Hoặc dashboard_path nếu bạn có trang chính khác
  end

  # Đường dẫn sau khi gửi email reset password
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name) # Chuyển về trang đăng nhập
  end
end
