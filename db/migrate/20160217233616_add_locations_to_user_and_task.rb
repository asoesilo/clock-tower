class AddLocationsToUserAndTask < ActiveRecord::Migration
  def change
    add_column :users, :location_id, :integer
    add_column :tasks, :location_id, :integer
  end
end
