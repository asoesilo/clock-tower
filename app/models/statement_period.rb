class StatementPeriod < ActiveRecord::Base
  VALID_TO_FROM = ('1'..'31').to_a.push('End of Month', 'Start of Month')

  validates :from, inclusion: { in: VALID_TO_FROM }
  validates :to, inclusion: { in: VALID_TO_FROM }
  validates :draft_days, numericality: { greater_than_or_equal_to: 0, only_integer: true }

end
