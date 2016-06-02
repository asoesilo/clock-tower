class SessionsController < ApplicationController

  skip_before_action :authenticate_user, only: [:new, :create, :destroy]
  before_action :to_home_if_logged_in, only: [:new, :create]

  def new
  end

  def create
    user = User.by_email(params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to new_time_entry_path
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
