class Admin::StatementPeriodsController < Admin::BaseController

  before_action :load_statement_period, only: [:edit, :update, :destroy]

  def index
    @statement_periods = StatementPeriod.all
  end

  def new
    @statement_period = StatementPeriod.new
  end

  def create
    @statement_period = StatementPeriod.new(statement_period_params)
    if @statement_period.save
      redirect_to admin_statement_periods_path, notice: "#{@statement_period.from} - #{@statement_period.to} Period created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @statement_period.update(statement_period_params)
      redirect_to admin_statement_periods_path, notice: "#{@statement_period.from} - #{@statement_period.to} Period updated."
    else
      render :edit
    end
  end

  def destroy
    @statement_period.destroy
    redirect_to [:admin, :statement_periods], notice: "#{@statement_period.from} - #{@statement_period.to} Period removed."
  end

  private

  def load_statement_period
    @statement_period = StatementPeriod.find(params[:id])
  end

  def statement_period_params
    params.required(:statement_period).permit(:to, :from, :draft_days)
  end

end