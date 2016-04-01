namespace :statement do
  desc "Find statement period ending today or date passed into DATE, ex DATE=2016-01-15, then create Statements if it exists"
  task daily_create: :environment do
      date = ENV['DATE']
      date = Date.parse(date) if date
      date ||= Date.today
      statement_period = StatementPeriod.where(to: date.day).first
      if statement_period.present?
        puts "Creating statements for #{statement_period.from_date(date).to_s(:humanly)} - #{statement_period.to_date(date).to_s(:humanly)}"
        CreateStatementsForPeriod.call(statement_period: statement_period)
      else
        puts "No statement periods found ending on #{date.to_s :humanly}"
      end
  end

  desc "Lock all statements with a post_date of either today / the date passed into DATE, ex DATE=2016-01-15"
  task daily_lock: :environment do
    date = ENV['DATE']
    date = Date.parse(date) if date
    date ||= Date.today
    puts "Locking statements for #{date.to_s(:humanly)}"
    LockStatementsForDate.call(date: date)
  end

  desc "Create Statements for all past time entries"
  task legacy_create: :environment do
    end_date = ENV['END_DATE']
    end_date = Date.parse(end_date) if end_date
    CreateLegacyStatements.call(end_date: end_date)
  end
end
