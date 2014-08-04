class HomeController < ApplicationController
  skip_before_action :authenticate_user
  skip_before_action :admin_access

  def show
  end
end