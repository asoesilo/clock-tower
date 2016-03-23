class LockStatementsForDate
  include Interactor

  def call
    @date = context[:date]
    statements.each do |statement|
      next unless statement.editable?
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
