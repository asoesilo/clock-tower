namespace :statement do
  desc "Find statement period ending today, create Statements if it exists"
  task daily_create: :environment do
      today = Date.today
      statement_period = StatementPeriod.where(to: today.day).first
      if statement_period.present?
        CreateStatementsForPeriod.call(statement_period: statement_period)
      end
  end

  desc "Lock all statements with a post_date of today"
  task daily_lock: :environment do
    LockStatementsForDate.call(date: Date.today)
  end

  desc "Create Legacy Statements"
  task legacy_create: :environment do
    end_date = ENV['END_DATE']
    end_date = Date.parse(end_date) if end_date
    CreateLegacyStatements.call(end_date: end_date)
  end
end
