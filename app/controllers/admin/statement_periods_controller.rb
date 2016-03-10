class Admin::StatementPeriodsController < Admin::BaseController

  def index
    @statement_periods = StatementPeriod.all
  end

  def show
  end

  def new
    @statement_period = StatementPeriod.new
  end

  def create  
  end

  def edit
  end

  def update
  end

  private

  def load_statement_period
    @statement_peroid = StatementPeriod.find(params[:id])
  end

  def statement_period_params
  end

end