class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by(email: params[:user][:email])

    if user.present? && user.valid_password?(params[:user][:password])
      super
    else
      redirect_to new_user_session_path,  alert: I18n.t("devise.errors.sessions.user.signed_in")
    end
  end
end