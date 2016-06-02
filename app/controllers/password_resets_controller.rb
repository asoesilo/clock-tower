class PasswordResetsController < ApplicationController

  before_action :to_home_if_logged_in
  skip_before_action :authenticate_user

  def show
    user = User.find_by(password_reset_token: params[:id])
    if user
      user.update password_reset_required: true, password_reset_token: nil
      session[:user_id] = user.id
      redirect_to :edit_password, notice: "Password Reset Required"
    else
      redirect_to :root, notice: "Invalid Password Reset Request, Please try again."
    end
  end

  def new
  end

  def create
    user = User.by_email(params[:email]).first
    if user
      user.update(password_reset_token: SecureRandom.hex(10))

      UserMailer.password_reset(user).deliver_now
      redirect_to :root, notice: "Password Reset sent to #{user.email}"
    else
      flash.now[:alert] = "Account with email #{params[:email]} not found"
      render :new
    end
  end

end
