namespace :statement do
  desc "Find statement period ending today, create Statements if it exists"
  task daily_create: :environment do
      today = Date.today
      statement_period = StatementPeriod.where(to: today.day).first
      if statement_period.present?
        CreateStatementsForPeriod.call(statement_period: statement_period)
      end
  end

end
