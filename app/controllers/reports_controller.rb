class ReportsController < ApplicationController
  def summary
    requirements = report_summary_params
    @time_entries = TimeEntry.query(requirements["from"], requirements["to"], requirements["users"], project_ids: requirements["projects"], task_ids: requirements["tasks"])

    # render json: @time_entries, status: :ok
  end

  def user
    requirements = report_user_params
    @time_entries = TimeEntry.query(requirements["from"], requirements["to"], [requirements["id"]])

    # render json: @time_entries, status: :ok
  end

  private
  def report_summary_params
    params.permit(:from, :to, users: [], projects: [], tasks: [])
  end

  def report_user_params
    params.permit(:id, :from, :to)
  end
end