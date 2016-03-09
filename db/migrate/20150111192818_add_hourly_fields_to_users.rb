class AddHourlyFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hourly, :boolean, default: true
    add_column :users, :rate, :float
    add_column :users, :secondary_rate, :float
  end
end
