class ReportsController < ApplicationController
  def summary
    requirements = report_summary_params
    @time_entries = TimeEntry.query(requirements["from"], requirements["to"], requirements["users"], project_ids: requirements["projects"], task_ids: requirements["tasks"])

    @from = requirements["from"]
    @to = requirements["to"]
    @users = User.where(id: requirements["users"])
    @projects = Project.where(id: requirements["projects"])
    @tasks = Task.where(id: requirements["tasks"])
    @total_duration = calculate_total_duration(@time_entries)
  end

  def user
    requirements = report_user_params
    @time_entries = TimeEntry.query(requirements["from"], requirements["to"], [requirements["user"]])

    @from = requirements["from"]
    @to = requirements["to"]
    @user = User.find_by(id: requirements["user"])
    @total_duration = calculate_total_duration(@time_entries)

    # binding.pry
  end

  private
  def report_summary_params
    params.permit(:from, :to, users: [], projects: [], tasks: [])
  end

  def report_user_params
    params.permit(:user, :from, :to)
  end

  def calculate_total_duration(entries)
    entries.inject(0) do |sum, entry|
      sum + entry.duration_in_hours
    end
  end
end