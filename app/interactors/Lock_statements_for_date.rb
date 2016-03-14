class LockStatementsForDate
  include Interactor

  def call
    @date = context[:date]
    statements.each do |statement|
      close_statement(statement)
    end
  end

  def statements
    Statement.where(post_date: @date)
  end

  def close_statement(statement)
    statement.transition_to(:locked)
  end

end
