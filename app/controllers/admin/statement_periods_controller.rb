class Admin::StatementPeriodsController < Admin::BaseController

  before_action :load_statement_period, only: [:edit, :update, :destroy, :show, :generate]

  def show
    set_select_dates
  end

  def generate
    date = Date.parse(params[:date])
    result = CreateStatementsForPeriod.call(statement_period: @statement_period, date: date)
    if result.statements && result.statements.length > 0
      redirect_to admin_statements_path(containing: @statement_period.from_date(date).to_s(:humanly)), notice: "#{result.statements.length} Statements created for #{@statement_period.to} - #{@statement_period.from}"
    else
      redirect_to [:admin, @statement_period], notice: "0 Statements created for #{@statement_period.to} - #{@statement_period.from}"
    end

  end

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

  def set_select_dates
    @dates = []
    date = 1.year.ago
    until date > 2.months.from_now
      @dates.unshift ["#{@statement_period.from_date(date).to_s(:humanly)} - #{@statement_period.to_date(date).to_s(:humanly)}", date.to_s(:humanly)]
      date += 1.month
    end
  end

  def statement_period_params
    params.required(:statement_period).permit(:to, :from, :draft_days)
  end

end
