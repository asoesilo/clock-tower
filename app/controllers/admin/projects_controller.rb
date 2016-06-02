class Admin::ProjectsController < Admin::BaseController
  before_filter :redirect_if_project_not_found, only: [:edit, :update, :delete]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
    @path = admin_projects_path
  end

  def create
    @project = Project.new(project_params)
    @project.creator = current_user

    if @project.save
      redirect_to admin_projects_path
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
    @path = admin_project_path
  end

  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(project_params)
      redirect_to admin_projects_path
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    
    @project.destroy
    redirect_to admin_projects_path, notice: "Project '#{@project.name}' deleted successfully"
  end

  private
  def project_params
    params.require(:project).permit(:name, :location_id)
  end

  def redirect_if_project_not_found
    if Project.find_by_id(params[:id]).nil?
      redirect_to admin_projects_path, alert: "Project cannot be found"
    end
  end
end