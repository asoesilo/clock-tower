class PasswordsController < ApplicationController

  skip_before_action :check_for_password_update

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.attributes = password_params
    if @user.valid?
      @user.password_reset_required = false
      @user.save
      redirect_to :root, notice: "Password updated, thanks!"
    else
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
