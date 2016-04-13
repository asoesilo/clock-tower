class LegacyStatementLock
  include Interactor

  def call
    @date = context[:date]
    @locked_statements = []
    statements.each do |statement|
      next unless statement.editable?
      close_statement(statement)
    end
    email_admin if @locked_statements.present?
  end

  def statements
    Statement.where(post_date: (@date.beginning_of_day..@date.end_of_day))
  end

  def close_statement(statement)
    if statement.transition_to(:legacy)
      @locked_statements.push (statement)
    end
  end

  def email_admin
    AdminMailer.legacy_statements_notify(@locked_statements).deliver_now
  end

end
