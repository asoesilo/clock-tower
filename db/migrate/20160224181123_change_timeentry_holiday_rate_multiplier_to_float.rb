class ChangeTimeentryHolidayRateMultiplierToFloat < ActiveRecord::Migration
  def change
    change_column :time_entries, :holiday_rate_multiplier, :float
  end
end
