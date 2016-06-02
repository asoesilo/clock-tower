class TaxRateToDecimal < ActiveRecord::Migration
  def change
    change_column :time_entries, :holiday_rate_multiplier, :decimal, precision: 4, scale: 2
    change_column :users, :holiday_rate_multiplier, :decimal, precision: 4, scale: 2
  end
end
