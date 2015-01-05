class HomeController < ApplicationController
  skip_before_action :authenticate_user

  def show
    redirect_to time_entries_path if is_logged_in?
  end
end