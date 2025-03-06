class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    
    if @user.persisted?
      sign_out_all_scopes 
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user , event: :authentication 
    else
      flash[:success] = t 'devise.omniauth_callbacks.failure', reason: 'User not found'
      redirect_to new_user_session_path

    end
  end
end
