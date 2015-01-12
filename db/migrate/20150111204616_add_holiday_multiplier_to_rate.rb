class AddHolidayMultiplierToRate < ActiveRecord::Migration
  def change
    add_column :users, :holiday_rate_multiplier, :float, default: 1.5
  end
end
