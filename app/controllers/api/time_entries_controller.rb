module Api
  class TimeEntriesController < ApplicationController
    skip_before_filter  :verify_authenticity_token

    def index
      render json: TimeEntry.all, status: :ok
    end

    def create
      time_entry = TimeEntry.new(time_entry_params)

      if time_entry.user_id.nil? && current_user
        time_entry.user_id = current_user.id
      end

      if time_entry.save
        render json: { entry: time_entry }, status: :ok
      else
        render json: { errors: time_entry.errors.full_messages }, status: :bad_request
      end
    end

    def update
      time_entry = TimeEntry.find_by(id: params[:id])
      if time_entry.update_attributes(time_entry_params)
        head :ok
      else
        render json: { errors: time_entry.errors.full_messages }, status: :bad_request
      end
    end

    def destroy
      time_entry = TimeEntry.find_by(id: params[:id])
      if time_entry.destroy
        head :ok
      else
        render json: { errors: time_entry.errors.full_messages }, status: :bad_request
      end
    end

    private
    def time_entry_params
      params.require(:time_entry).permit(:user_id, :project_id, :task_id, :entry_date, :duration_in_hours, :comments)
    end
  end
end