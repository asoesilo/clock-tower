class Admin::StatementsController < Admin::BaseController
  include StatementQueries

  before_action :load_statement, only: [:show, :update]

  def index
    @all_users = User.all
    @statements = Statement.page(params[:page]).per(25).order(to: :desc)

    @statements = @statements.containing_date(params[:containing]) if params[:containing].present?
    @statements = @statements.in_state(params[:state]) if params[:state].present?
    @statements = @statements.by_users(params[:users]) if params[:users].present?
  end

  def show
    @entries = entries_by_date(@statement)
  end

  def pay
  end

  def update
    if @statement.transition_to(params[:state])
      flash[:notice] = "Successfully transitioned to #{params[:state].capitalize}"
    else
      flash[:notice] = "Unable to transition to #{params[:state].capitalize}"
    end
    redirect_to [:admin, @statement]
  end

  def new
    @users = User.active
  end

  def create
    users = params[:users]

    to = Date.parse(params[:to])
    from = Date.parse(params[:from])
    post_date = Date.parse(params[:post_date])

    users.each do |user_id|
      user = User.find(user_id)
      CreateStatement.call(user: user, to: to, from: from, post_date: post_date)
    end
    redirect_to admin_statements_path
  end

  private

  def load_statement
    @statement = Statement.find(params[:id])
  end

end
