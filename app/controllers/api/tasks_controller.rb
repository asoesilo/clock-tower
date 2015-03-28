class Api::TasksController < Api::BaseController

  def index
    render json: Task.all, status: :ok
  end

end