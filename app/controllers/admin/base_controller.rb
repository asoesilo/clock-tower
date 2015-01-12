class Admin::BaseController < ApplicationController
  before_action :admin_access
  before_action :on_admin

  private
  def admin_access
    redirect_to root_path, alert: "Admin access required!" unless current_user && current_user.is_admin?
  end

  def on_admin
    @admin = true
  end
end