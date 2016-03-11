class CreateStatementsForPeriod
  include Interactor

  def call
    @today = Date.today
    set_statement_period
    fetch_users
    create_statements
  end

  private

  def set_statement_period
    @statement_period = StatementPeriod.where(to: @today.day).take
    if @statement_period.blank?
      context.errors = "No Statements end today"
      context.fail!
    end

    @to = @statement_period.to_date
    @from = @statement_period.from_date
    @end_date = @statement_period.draft_end_date
  end

  def fetch_users
    user_ids = TimeEntry.between(@from, @to).where(apply_rate: true).pluck(:user_id).uniq
    if user_ids.blank?
      context.errors = "No Users found with valid entries between #{@from} - #{@to}"
      context.fail!
    end

    @users = user_ids.map do |user_id| 
      User.find(user_id)
    end
  end

  def create_statements
    @users.each do |user|
      res = CreateStatement.call(to: @to, from: @from, user: user, post_date: @end_date)
      if res.success?
        puts "Created Statement for #{user.fullname}"
      else
        puts "Statement could not be created fo #{user.fullname}"
      end
    end
  end
end
