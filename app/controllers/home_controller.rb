class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    # redirect_to root_path
  end
end
