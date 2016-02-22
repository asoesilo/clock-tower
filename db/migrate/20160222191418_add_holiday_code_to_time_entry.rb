class AddHolidayCodeToTimeEntry < ActiveRecord::Migration
  def change
    add_column :time_entries, :holiday_code, :string
    add_column :projects, :location_id, :integer
    remove_column :tasks, :location_id, :integer
  end
end
