class Admin::TasksController < Admin::BaseController
  before_filter :redirect_if_task_not_found, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
    @path = admin_tasks_path
  end

  def create
    @task = Task.new(task_params)
    @task.creator = current_user

    if @task.save
      redirect_to admin_tasks_path
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
    @path = admin_task_path
  end

  def update
    @task = Task.find(params[:id])

    @task.assign_attributes(task_params)
    @task.assign_attributes({ creator: current_user })

    if @task.save
      redirect_to admin_tasks_path
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    
    @task.destroy
    redirect_to admin_tasks_path, notice: "Task '#{@task.name}' deleted successfully"
  end

  private
  def task_params
    params.require(:task).permit(:name)
  end

  def redirect_if_task_not_found
    if Task.find_by_id(params[:id]).nil?
      redirect_to admin_tasks_path, alert: "Task cannot be found"
    end
  end
end
