class Admin::StatementsController < Admin::BaseController

  before_action :load_statement, only: [:show]

  def index
    @all_users = User.all
    @containing = params[:containing]
    @statements = Statement.all

    @statements = @statements.containing_date(params[:containing]) if params[:containing].present?
    @statements = @statements.by_users(params[:users]) if params[:users].present?
  end

  def show
  end

  private

  def load_statement
    @statement = Statement.find(params[:id])
    @entries = @statement.time_entries.order(:entry_date)
    .group(:entry_date, :rate, :tax_percent)
    .select("
        SUM(duration_in_hours) AS hours,
        SUM(duration_in_hours * rate * (tax_percent / 100)) AS tax,
        SUM(duration_in_hours * rate) as total,
        tax_percent,
        entry_date,
        rate
      ")
  end

end