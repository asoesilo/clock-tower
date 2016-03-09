class AddLocationIdToTimeEntry < ActiveRecord::Migration
  def change
    add_column :time_entries, :location_id, :integer
  end
end
