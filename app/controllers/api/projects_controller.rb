module Api
  class ProjectsController < ApplicationController
    def index
      render json: Project.all, status: :ok
    end
  end
end