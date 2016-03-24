class StatementPeriod < ActiveRecord::Base
  VALID_TO_FROM = ('1'..'31').to_a.push('End of Month', 'Start of Month')

  validates :from, inclusion: { in: VALID_TO_FROM }
  validates :to, inclusion: { in: VALID_TO_FROM }
  validates :draft_days, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def from_date(date)
    parse_date(from, date).beginning_of_day
  end

  def to_date(date)
    parse_date(to, date).end_of_day
  end

  def draft_end_date(date)
    to_date(date).advance(days: draft_days)
  end

  private

  def parse_date(string, date)
    case string
    when 'End of Month'
      date.end_of_month
    when 'Start of Month'
      date.beginning_of_month
    else
      Date.new(date.year, date.month, string.to_i)
    end
  end

end
