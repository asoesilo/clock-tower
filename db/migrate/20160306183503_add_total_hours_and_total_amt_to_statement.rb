class AddTotalHoursAndTotalAmtToStatement < ActiveRecord::Migration
  def change
    add_column :statements, :hours, :decimal 
    add_column :statements, :total, :decimal 
  end
end
