class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def to_home_if_logged_in
    redirect_to :root, alert: "You are already logged in" if current_user
  end

  private

  def authenticate_user
    redirect_to new_session_path, alert: "Please login first!" unless current_user
  end

  helper_method :current_user
end
