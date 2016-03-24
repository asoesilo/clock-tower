class CreateStatement
  include Interactor

  def call
    context.fail! unless required_params?
    @user = context[:user]
    context.statement = @statement = Statement.create!(statement_params)
    email_user unless context[:dont_email_user]
  end

  private

  def entries
    context[:user].time_entries.where(apply_rate: true, statement_id: nil).between(context[:from], context[:to])
  end

  def required_params?
    context[:to].present? && context[:from].present? && context[:user].present? && context[:post_date].present?
  end

  def statement_params
    {
      to: context[:to],
      from: context[:from],
      time_entries: entries,
      user: @user,
      post_date: context[:post_date]
    }
  end

  def email_user
    UserMailer.statement_created(@user, @statement).deliver_now
  end
end
