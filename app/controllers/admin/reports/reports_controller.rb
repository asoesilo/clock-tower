class Admin::Reports::ReportsController < Admin::Reports::BaseController

  def summary
    requirements = report_summary_params
    @time_entries = TimeEntry.query(
      requirements["from"], 
      requirements["to"], 
      requirements["users"], 
      requirements["projects"], 
      requirements["tasks"]
    )

    @from = requirements["from"].present? ? Date.parse(requirements["from"]) : Date.today.beginning_of_week
    @to = requirements["to"].present? ? Date.parse(requirements["to"]) : Date.today
    @users = User.where(id: requirements["users"])
    @projects = Project.where(id: requirements["projects"])
    @tasks = Task.where(id: requirements["tasks"])
    @total_duration = calculate_total_duration(@time_entries)
  end

  private

  def report_summary_params
    params.permit(:from, :to, users: [], projects: [], tasks: [])
  end

  def calculate_total_duration(entries)
    entries.inject(0) do |sum, entry|
      sum + entry.duration_in_hours
    end
  end
  
end