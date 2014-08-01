module Api
  class ProfileController < ApplicationController
    def time_entries
      render json: TimeEntry.where(user_id: current_user.id), status: :ok
    end
  end
end