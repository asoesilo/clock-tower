module Api
  class ProjectsController < ApplicationController
    skip_before_action :admin_access, only: [:index]

    def index
      render json: Project.all, status: :ok
    end
  end
end