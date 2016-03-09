class Admin::Reports::BaseController < Admin::BaseController

  before_action :report_collections

  private

  def report_collections
    @all_projects = Project.all
    @all_tasks = Task.all
    @all_users = User.order(lastname: :asc, firstname: :asc)
  end

end
