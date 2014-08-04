module Api
  class UsersController < ApplicationController
    skip_before_action :admin_access, only: [:index]

    def index
      render json: User.all, status: :ok
    end
  end
end