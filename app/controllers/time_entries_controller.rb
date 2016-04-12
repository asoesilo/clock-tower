class TimeEntriesController < ApplicationController

  before_filter :validate_time_entry_update, only: [:edit, :update, :destroy]

  def index
    @all_projects = Project.all
    @all_tasks = Task.all
    @statements = current_user.statements

    @from = params[:from]
    @to = params[:to]
    @on = params[:on]
    @time_entries = current_user.time_entries
    @time_entries = current_user.statements.find(params[:statement]).time_entries if params[:statement].present?

    @time_entries = @time_entries.where(project_id: params[:projects]) if params[:projects].present?
    @time_entries = @time_entries.where(task_id: params[:tasks]) if params[:tasks].present?
    @time_entries = @time_entries.where(entry_date: Date.parse(@on)) if @on.present?
    @time_entries = @time_entries.between(Date.parse(@from), Date.parse(@to)) if @from.present? && @to.present?

    @time_entries = @time_entries.page(params[:page]).per(25).order(entry_date: :desc, id: :asc)
  end

  def new
  end

end
