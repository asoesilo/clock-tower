class UsersController < ApplicationController

  before_filter :verify_api_key
  skip_before_filter :verify_authenticity_token

  # Not a user endpoint but rather an external (non Angular) API endpoint
  # For automatic creation of users. JSON only
  
  def create
    user = User.new(
      email: params[:email],
      password: params[:email],
      firstname: params[:firstname],
      lastname: params[:lastname],
      rate: params[:rate],
      hourly: true,
      active: true
    )
    if user.save
      render json: {
        success: true,
        id: user.id
      }, status: :ok
    else
      render json: {
        success: false,
        errors: user.errors.full_messages
      }, status: :bad_request
    end
  end

  def destroy
    user = User.where(admin: [false, nil]).find(params[:id])
    user.update_attributes(active: false)
    render json: {
      success: true
    }, status: :ok
  end

  private

  def verify_api_key
    unless params[:api_key] == ENV['API_KEY']
      render json: { 
        errors: ["API KEY INVALID"]
      }, status: :bad_request
    end
  end


end
