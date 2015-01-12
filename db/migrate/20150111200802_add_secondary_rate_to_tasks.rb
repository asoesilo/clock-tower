class AddSecondaryRateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :apply_secondary_rate, :boolean
  end
end
