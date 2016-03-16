class UpdateStatement
  include Interactor

  def call
    @statement = context[:statement]
    context.fail! unless statement_editable?
    add_entries_to_statement
    context.statement = @statement.update!(statement_params)
  end

  private

  def statement_editable?
    @statement && @statement.state == 'pending'
  end

  def statement_params
    {
      subtotal: subtotal,
      tax_amount: tax_total,
      total: (tax_total + subtotal),
      hours: total_hours
    }
  end

  def add_entries_to_statement
    @statement.time_entries << new_entries
  end

  def new_entries
    @statement.user.time_entries.where(apply_rate: true, statement_id: nil).between(@statement.from, @statement.to)
  end

  def entries
    @statement.time_entries
  end

  def tax_total
    entries.where(has_tax: true).sum("duration_in_hours * rate * (tax_percent / 100)")
  end

  def total_hours
    entries.sum("duration_in_hours")
  end

  def subtotal
    entries.sum("duration_in_hours * rate")
  end

end
