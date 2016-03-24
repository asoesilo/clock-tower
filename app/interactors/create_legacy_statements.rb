class CreateLegacyStatements
  include Interactor

  before do
    @start = Time.now
  end

  after do
    p Time.now - @start
  end

  def call
    @date = TimeEntry.where(statement_id: nil).order(entry_date: :asc).first.entry_date
    @periods = StatementPeriod.all

    until @date >= 1.month.ago.end_of_month
      create_statements_for_month
      @date = @date.advance(months: 1)
    end
  end

  def create_statements_for_month
    @periods.each do |period|
      res = CreateStatementsForPeriod.call(statement_period: period, date: @date, dont_email_user: true)
      void_statements(res.statements) if res.success?
    end
  end

  def void_statements(statements)
    statements.each do |statement|
      statement.transition_to(:void)
    end
  end

end
