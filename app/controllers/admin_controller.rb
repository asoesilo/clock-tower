class AdminController < ApplicationController
  before_action :admin_access

  private
  def admin_access
    redirect_to root_path, alert: "Admin access required!" if current_user && !current_user.is_admin?
  end
end