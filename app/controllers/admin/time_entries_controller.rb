class Admin::TimeEntriesController < Admin::BaseController

  def index
    @all_projects = Project.all
    @all_tasks = Task.all
    @all_users = User.all
    @from = params[:from]
    @to = params[:to]
    @on = params[:on]
    @time_entries = TimeEntry.order(entry_date: :desc, id: :asc)

    @time_entries = @time_entries.where(user_id: params[:users]) if params[:users].present?
    @time_entries = @time_entries.where(project_id: params[:projects]) if params[:projects].present?
    @time_entries = @time_entries.where(task_id: params[:tasks]) if params[:tasks].present?
    @time_entries = @time_entries.where(entry_date: Date.parse(@on)) if @on.present?
    @time_entries = @time_entries.between(Date.parse(@from), Date.parse(@to)) if @from.present? && @to.present?

    @time_entries = @time_entries.page(params[:page]).per(25)
  end
end
