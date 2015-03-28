class SessionsController < ApplicationController
  
  skip_before_action :authenticate_user, only: [:new, :create, :destroy]
  before_action :to_home_if_logged_in, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to :time_entries
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    reset_session if current_user
    redirect_to :root, notice: "You have been logged out."
  end

end
