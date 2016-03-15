class TimeEntriesController < ApplicationController

  before_filter :validate_time_entry_update, only: [:edit, :update, :destroy]

  def index
    @all_projects = Project.all
    @all_tasks = Task.all
    @from = params[:from]
    @to = params[:to]
    @on = params[:on]
    @time_entries = current_user.time_entries.order(entry_date: :desc)
  end

  def new
  end

end
