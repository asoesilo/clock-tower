module Admin::StatementPeriodsHelper

  def month_select
    (1..31).to_a.push('End of Month').unshift('Start of Month')
  end

end
