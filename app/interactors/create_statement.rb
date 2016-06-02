class CreateStatement
  include Interactor

  def call
    context.fail! unless required_params?
    @user = context[:user]
    context.statement = @statement = Statement.create!(statement_params)
    @statement.time_entries << entries
    email_user if email_user?
  end

  private

  def email_user?
    !context[:dont_email_user] && @statement.total > 0
  end

  def entries
    context[:user].time_entries.with_no_statement.before(context[:to])
  end

  def required_params?
    context[:to].present? && context[:from].present? && context[:user].present? && context[:post_date].present?
  end

  def statement_params
    {
      to: context[:to],
      from: context[:from],
      user: @user,
      post_date: context[:post_date]
    }
  end

  def email_user
    UserMailer.statement_created(@user, @statement).deliver_now
  end
end
