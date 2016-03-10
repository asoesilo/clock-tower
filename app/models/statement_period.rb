class StatementPeriod < ActiveRecord::Base
  VALID_TO_FROM = ('1'..'31').to_a.push('End of Month', 'Start of Month')

  validates :from, inclusion: { in: VALID_TO_FROM }
  validates :to, inclusion: { in: VALID_TO_FROM }
  validates :draft_days, presence: true

end
