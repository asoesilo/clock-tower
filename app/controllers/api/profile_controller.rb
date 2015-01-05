module Api
  class ProfileController < ApplicationController
    skip_before_action :admin_access, only: [:time_entries]

    def time_entries
      @entries = current_user.time_entries.order(entry_date: :desc)
      render json: {
        num_entries: @entries.count,
        entries: @entries.limit(50),
        total_hours: @entries.sum(:duration_in_hours)
      }
    end
  end
end