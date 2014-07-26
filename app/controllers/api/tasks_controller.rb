module Api
  class TasksController < ApplicationController
    def index
      render json: Task.all, status: :ok
    end
  end
end