class CreateStatement
  include Interactor

  def call
    context.fail! unless required_params?
    context.statement = Statement.create!(statement_params)
  end

  private

  def tax_total
    entries.where(has_tax: true).sum("duration_in_hours * rate * (tax_percent / 100)")
  end

  def subtotal
    entries.sum("duration_in_hours * rate")
  end

  def entries
    context[:user].time_entries.where(apply_rate: true, statement_id: nil).where("time_entries.entry_date >= ? AND time_entries.entry_date <= ?", context[:from], context[:to])
  end

  def required_params?
    context[:to].present? && context[:from].present? && context[:user].present? && context[:post_date].present?
  end

  def total_hours
    entries.sum("duration_in_hours")
  end

  def statement_params
    {
      to: context[:to],
      from: context[:from],
      subtotal: subtotal,
      tax_amount: tax_total,
      time_entries: entries,
      user: context[:user],
      total: (tax_total + subtotal),
      hours: total_hours,
      post_date: context[:post_date]
    }
  end
end
