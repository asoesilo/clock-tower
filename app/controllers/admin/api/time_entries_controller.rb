class Admin::Api::TimeEntriesController < Admin::BaseController
  skip_before_filter :verify_authenticity_token

  before_action :load_entry, only: [:update, :destroy]

  def update
    if @time_entry.update(time_entry_params)
      render json: { entry: @time_entry }, status: :ok
    else
      render json: { errors: @time_entry.errors.full_messages.try(:join, ', ') }, status: :bad_request
    end
  end

  def destroy
    if @time_entry.destroy
      head :ok
    else
      render json: { errors: @time_entry.errors.full_messages.try(:join, ', ') }, status: :bad_request
    end
  end


  private
  
  def load_entry
    @time_entry = TimeEntry.find(params[:id])
  end

  def time_entry_params
    params.require(:time_entry).permit(:project_id, :task_id, :entry_date, :duration_in_hours, :comments, :rate, :has_tax, :tax_percent, :tax_desc, :apply_rate, :is_holiday, :apply_rate)
  end
end
