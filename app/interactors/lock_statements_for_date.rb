class LockStatementsForDate
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
    if statement.transition_to(:locked)
      if statement.total == 0
        statement.transition_to(:paid)
      else
        @locked_statements.push (statement)
      end
    end
  end

  def email_admin
    AdminMailer.locked_statements_notify(@locked_statements).deliver_now
  end

end
