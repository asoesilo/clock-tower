class ProfilesController < ApplicationController
  
  skip_before_action :authenticate_user, only: [:new, :create]
  before_action :to_home_if_logged_in

  def new
    @user = User.new
    @path = profile_path
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id # auto log in
      redirect_to root_path, notice: "Welcome aboard, #{@user.fullname}!"
    else
      @email = @user.email
      @firstname = @user.firstname
      @lastname = @user.lastname

      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end

end