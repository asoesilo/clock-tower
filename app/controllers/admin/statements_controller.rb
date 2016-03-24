class Admin::StatementsController < Admin::BaseController
  include StatementQueries

  def index
    @all_users = User.all
    @statements = Statement.page(params[:page]).per(25)

    @containing = params[:containing]
    @statements = @statements.containing_date(params[:containing]) if params[:containing].present?
    @statements = @statements.by_users(params[:users]) if params[:users].present?
  end

  def show
    @statement = Statement.find(params[:id])
    @entries = entries_by_date @statement
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
end
