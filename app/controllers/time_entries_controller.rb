class TimeEntriesController < ApplicationController
  before_filter :validate_time_entry_update, only: [:edit, :update, :destroy]

  def index
    @time_entries = TimeEntry.all
  end

  def new
    @time_entry = TimeEntry.new
  end

  def create
    @time_entry = TimeEntry.new(time_entries_params)
    @time_entry.user = current_user

    if @time_entry.save
      redirect_to time_entries_path
    else
      renders :new
    end
  end

  def edit
    @time_entry = TimeEntry.find(params[:id])
  end

  def update
    @time_entry = TimeEntry.find(params[:id])
    @time_entry.assign_attributes(time_entries_params)
    @time_entry.user = current_user

    if @time_entry.save
      redirect_to time_entries_path
    else
      renders :edit
    end
  end

  def destroy
    @time_entry = TimeEntry.find(params[:id])
    @time_entry.destroy
    redirect_to time_entries_path
  end

  private
  def time_entries_params
    params.require(:time_entry).permit(:project_id, :task_id, :entry_date, :duration_in_hours, :comments)
  end

  def validate_time_entry_update
    if validate_is_entry_not_found
      validate_is_creator
    end
  end

  def validate_is_entry_not_found
    if TimeEntry.find(params[:id]).nil?
      redirect_to time_entries_path, alert: "Time entry cannot be found"
      return false
    end
    true
  end

  def validate_is_creator
    time_entry = TimeEntry.find(params[:id])
    if time_entry.user != current_user
      redirect_to time_entries_path, alert: "Cannot modify time entries created by other users"
    end
  end
end
