class RemoveHolidayCodeFromLocation < ActiveRecord::Migration
  def change
    remove_column :locations, :holiday_code, :string
  end
end
