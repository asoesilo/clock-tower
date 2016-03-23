class Api::TimeEntriesController < Api::BaseController

  def index
    @entries = current_user.time_entries.order(entry_date: :desc)
    render json: {
      num_entries: @entries.count,
      entries: @entries.limit(25),
      total_hours: @entries.sum(:duration_in_hours)
    }
  end

  def create
    result = CreateTimeEntry.call(new_params)
    if result.success?
      render json: { entry: result.time_entry }, status: :ok
    else
      render json: { errors: result.errors }, status: :bad_request
    end
  end

  def update
    time_entry = current_user.time_entries.find(params[:id])
    result = UpdateTimeEntry.call(update_params(time_entry))

    if result.success?
      render json: { entry: result.time_entry }, status: :ok
    else
      render json: { errors: result.errors }, status: :bad_request
    end
  end

  def destroy
    time_entry = current_user.time_entries.find(params[:id])

    if time_entry.destroy
      head :ok
    else
      render json: { errors: time_entry.errors.full_messages }, status: :bad_request
    end
  end

  private

  def new_params
    time_entry_params.merge({ user: current_user })
  end

  def update_params(time_entry)
    time_entry_params.merge({ time_entry: time_entry })
  end

  def time_entry_params
    params.require(:time_entry).permit(:project_id, :task_id, :entry_date, :duration_in_hours, :comments)
  end

end
