class Admin::ProfileController < Admin::ApplicationController
  def index
    @admin = current_user
  end
  def show
    @admin = current_user
  end
end
