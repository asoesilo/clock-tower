class LegacyStatementLock
  include Interactor

  def call
    @date = context[:date]
    @legacy_statements = []
    statements.each do |statement|
      next unless statement.editable?
      close_statement(statement)
    end
    email_admin if @legacy_statements.present?
  end

  def statements
    Statement.where(post_date: (@date.beginning_of_day..@date.end_of_day))
  end

  def close_statement(statement)
    if statement.transition_to(:legacy)
      @legacy_statements.push (statement)
    end
  end

  def email_admin
    AdminMailer.legacy_statements_notify(@legacy_statements).deliver_now
  end

end
