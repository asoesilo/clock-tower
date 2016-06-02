class ProfilesController < ApplicationController

  before_action :load_user

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to :root, notice: "Account successfully updated"
    else
      render :edit
    end
  end

  private

  def load_user
    @user = current_user
  end

  def profile_params
    permitted_params = [:firstname, :lastname, :company_name, :tax_number, :has_tax, :email]
    permitted_params.push(:receive_admin_email) if current_user.is_admin?

    params.require(:user).permit(permitted_params)
  end

end
