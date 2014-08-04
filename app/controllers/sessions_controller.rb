class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:new, :create, :destroy]
  skip_before_action :admin_access, only: [:new, :create, :destroy]
  
  before_action :to_home_if_logged_in, only: [:new, :create]

  def new
    @email = ""
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to :root, notice: "Welcome back, #{user.fullname}"
    else
      flash[:alert] = "Invalid email or password"

      @email = params[:email]
      render :new
    end
  end

  def destroy
    if current_user
      reset_session
    else
      flash[:notice] = "You are not logged in!"
    end

    redirect_to :root
  end
end
