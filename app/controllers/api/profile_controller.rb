module Api
  class ProfileController < ApplicationController
    skip_before_action :admin_access, only: [:time_entries]

    def time_entries
      render json: TimeEntry.where(user_id: current_user.id), status: :ok
    end
  end
end