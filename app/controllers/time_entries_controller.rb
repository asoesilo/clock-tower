class TimeEntriesController < ApplicationController

  before_filter :validate_time_entry_update, only: [:edit, :update, :destroy]

  def index
  end

end
