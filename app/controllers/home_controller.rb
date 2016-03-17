class HomeController < ApplicationController

  skip_before_action :authenticate_user

  def show
    redirect_to new_time_entry_path if is_logged_in?
  end

end
