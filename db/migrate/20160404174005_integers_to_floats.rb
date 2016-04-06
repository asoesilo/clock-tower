class IntegersToFloats < ActiveRecord::Migration
  def up
    change_column :time_entries, :rate, :decimal, precision: 5, scale: 2
    change_column :time_entries, :duration_in_hours, :decimal, precision: 5, scale: 2
    change_column :users, :rate, :decimal, precision: 5, scale: 2
    change_column :users, :secondary_rate, :decimal, precision: 5, scale: 2
  end
  def down
    change_column :time_entries, :rate, :integer
    change_column :time_entries, :duration_in_hours, :float
    change_column :users, :rate, :float
    change_column :users, :secondary_rate, :float
  end
end
