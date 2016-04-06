class Admin::Reports::PayrollController < Admin::Reports::BaseController

  def show
    @from = report_params[:from].present? ? Date.parse(report_params[:from]) : Date.today.beginning_of_week
    @to = report_params[:to].present? ? Date.parse(report_params[:to]) : Date.today
    @all_users = User.all.order(lastname: :asc, firstname: :asc)
    @users = @all_users.where(id: report_params[:users]) if report_params[:users].present?
    @reporting_users = @users || @all_users

    @entries_by_user = {}

    @reporting_users.each do |user|
      reporter = GenerateReportEntries.call(
        from: @from,
        to: @to,
        user: user,
        project_ids: report_params[:projects],
        task_ids: report_params[:tasks])

      @entries_by_user[user.id.to_s] = {
        regular: reporter.regular_entries,
        holiday: reporter.holiday_entries
      }
    end

  end

  private

  def report_params
    params.permit(:from, :to, users: [], projects: [], tasks: [])
  end

end
