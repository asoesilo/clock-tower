class PasswordResetsController < ApplicationController

  before_action :to_home_if_logged_in
  skip_before_action :authenticate_user

  def new
  end

  def create
  end

end
