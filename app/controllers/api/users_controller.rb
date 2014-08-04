module Api
  class UsersController < ApplicationController
    def index
      render json: User.all, status: :ok
    end
  end
end