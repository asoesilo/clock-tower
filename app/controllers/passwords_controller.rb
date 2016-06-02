class PasswordsController < ApplicationController

  skip_before_action :check_for_password_update

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.attributes = password_params
    @user.password_reset_required = false
    if !password_blank? && @user.valid?
      @user.save
      redirect_to :root, notice: "Password updated, thanks!"
    else
      flash.now[:notice] = "Invalid password update."
      render :edit
    end
  end

  private

  def password_blank?
    password_params[:password].blank? || password_params[:password_confirmation].blank?
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
