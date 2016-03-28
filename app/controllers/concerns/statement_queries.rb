module StatementQueries

  def entries_by_date(statement)
    statement.time_entries.order(:entry_date)
    .group(:entry_date, :rate, :tax_percent, :has_tax, :apply_rate)
    .select("
        SUM(duration_in_hours) AS hours,
        SUM(duration_in_hours * rate * (tax_percent / 100)) AS tax,
        SUM(duration_in_hours * rate) as total,
        tax_percent,
        entry_date,
        rate,
        has_tax,
        apply_rate
      ")
  end
end
