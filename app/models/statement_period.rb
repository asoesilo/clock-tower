class StatementPeriod < ActiveRecord::Base
  VALID_TO_FROM = ('1'..'31').to_a.push('End of Month', 'Start of Month')

  validates :from, inclusion: { in: VALID_TO_FROM }
  validates :to, inclusion: { in: VALID_TO_FROM }
  validates :draft_days, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def from_date
    parse_date(from)
  end

  def to_date
    parse_date(to)
  end

  def draft_end_date
    to_date.advance(days: draft_days)
  end

  private

  def parse_date(string)
    today = Date.today
    case string
    when 'End of Month'
      today.end_of_month
    when 'Start of Month'
      today.beginning_of_month
    else
      Date.new(today.year, today.month, string.to_i)
    end
  end

end
