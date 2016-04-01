class Admin::Reports::SummaryController < Admin::Reports::BaseController

  def show
    @time_entries = TimeEntry.query(
      report_params[:from],
      report_params[:to],
      report_params[:users],
      report_params[:projects],
      report_params[:tasks]
    )

    @from = report_params[:from].present? ? Date.parse(report_params[:from]) : Date.today.beginning_of_week
    @to = report_params[:to].present? ? Date.parse(report_params[:to]) : Date.today
    @total_duration = total_duration(@time_entries)
  end

  private

  def report_params
    params.permit(:from, :to, :users, projects: [], tasks: [])
  end

  def total_duration(entries)
    entries.inject(0) { |sum, entry| sum + entry.duration_in_hours }
  end

end
