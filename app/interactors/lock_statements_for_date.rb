class LockStatementsForDate
  include Interactor

  def call
    @date = context[:date]
    statements.each do |statement|
      next if statement.state != 'pending'
      UpdateStatement.call(statement: statement)
      close_statement(statement)
    end
  end

  def statements
    Statement.where(post_date: (@date.beginning_of_day...@date.end_of_day))
  end

  def close_statement(statement)
    statement.transition_to(:locked)
  end

end
