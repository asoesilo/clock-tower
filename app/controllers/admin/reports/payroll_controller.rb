class Admin::Reports::PayrollController < Admin::Reports::BaseController

  def show
    @from = report_params[:from].present? ? Date.parse(report_params[:from]) : Date.today
    @to = report_params[:to].present? ? Date.parse(report_params[:to]) : Date.today
    @all_users = User.all.hourly.order(lastname: :asc, firstname: :asc)
    @users = @all_users.where(id: report_params[:users]) if report_params[:users].present?
    @reporting_users = @users || @all_users

    @entries_by_user = {}

    reporter = ::Reports::Entries.new(@from, @to)

    @reporting_users.each do |user|
      @entries_by_user[user.id.to_s] = {
        regular: reporter.regular_entries_for(user),
        holiday: reporter.holiday_entries_for(user)
      }
    end

  end

  private

  def report_params
    params.permit(:from, :to, users: [])
  end

end
