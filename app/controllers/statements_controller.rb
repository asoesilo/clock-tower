class StatementsController < ApplicationController

  def index
    @statements = current_user.statements
  end

  def show
    @statement = current_user.statements.find(params[:id])
    @entries = @statement.time_entries.order(:entry_date)
    .group(:entry_date, :rate)
    .select("SUM(duration_in_hours) AS hours, SUM(duration_in_hours * rate) AS total, entry_date, rate")
  end

end
