module Api
  class TasksController < ApplicationController
    skip_before_action :admin_access, only: [:index]

    def index
      render json: Task.all, status: :ok
    end
  end
end