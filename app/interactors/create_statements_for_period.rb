class CreateStatementsForPeriod
  include Interactor

  def call
    @statement_period = context[:statement_period]
    set_statement_dates
    fetch_users
    create_statements
  end

  private

  def set_statement_dates
    @date = context[:date] || Date.today
    @to = @statement_period.to_date(@date)
    @from = @statement_period.from_date(@date)
    @end_date = @statement_period.draft_end_date(@date)
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
    context.statements = []
    @users.each do |user|
      res = CreateStatement.call(to: @to, from: @from, user: user, post_date: @end_date, dont_email_user: context[:dont_email_user])
      if res.success?
        context.statements.push(res.statement)
        puts "Created Statement for #{user.fullname}"
      else
        puts "Statement could not be created for #{user.fullname}"
      end
    end
  end
end
