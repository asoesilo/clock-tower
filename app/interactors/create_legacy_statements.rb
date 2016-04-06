class CreateLegacyStatements
  include Interactor

  def call
    @date = TimeEntry.with_no_statement.order(entry_date: :asc).first.entry_date
    @periods = StatementPeriod.all
    @end_date = context[:end_date] || Date.today.beginning_of_month

    until @date >= @end_date.end_of_month
      create_statements_for_month
      @date = @date.advance(months: 1)
    end
  end

  def create_statements_for_month
    @periods.each do |period|
      if (@end_date > period.to_date(@date))
        p "#{period.from_date(@date).to_s(:humanly)} - #{period.to_date(@date).to_s(:humanly)}"
        res = CreateStatementsForPeriod.call(statement_period: period, date: @date, dont_email_user: true)
        void_statements(res.statements) if res.success?
      end
    end
  end

  def void_statements(statements)
    statements.each do |statement|
      statement.transition_to(:legacy)
    end
  end

end
