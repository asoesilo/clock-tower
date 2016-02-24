class AddHourlyToTimeEntry < ActiveRecord::Migration
  def change
    add_column :time_entries, :rate, :integer
  end
end
