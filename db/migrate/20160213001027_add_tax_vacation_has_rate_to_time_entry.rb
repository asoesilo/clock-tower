class AddTaxVacationHasRateToTimeEntry < ActiveRecord::Migration
  def change
    add_column :time_entries, :apply_rate, :boolean
    add_column :time_entries, :is_holiday, :boolean
    add_column :time_entries, :holiday_rate_multiplier, :integer
  end
end
