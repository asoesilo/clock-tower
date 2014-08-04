class ReportsController < ApplicationController
  def summary
    requirements = report_summary_params
    @time_entries = TimeEntry.query(requirements["from"], requirements["to"], requirements["users"], project_ids: requirements["projects"], task_ids: requirements["tasks"])

    @from = requirements["from"]
    @to = requirements["to"]
    @users = User.where(id: requirements["users"])
    @projects = Project.where(id: requirements["projects"])
    @tasks = Task.where(id: requirements["tasks"])
  end

  def user
    requirements = report_user_params
    @time_entries = TimeEntry.query(requirements["from"], requirements["to"], [requirements["id"]])

    @from = requirements["from"]
    @to = requirements["to"]
    @user = User.find_by(id: requirements["id"])
  end

  private
  def report_summary_params
    params.permit(:from, :to, users: [], projects: [], tasks: [])
  end

  def report_user_params
    params.permit(:id, :from, :to)
  end
end