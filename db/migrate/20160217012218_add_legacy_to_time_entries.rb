class AddLegacyToTimeEntries < ActiveRecord::Migration
  
  def up
    add_column :time_entries, :legacy, :boolean
    # This will call the before_save callbacks to set rate and holiday information on TimeEntry.
    # TimeEntry.update_all wouldnt work
    TimeEntry.find_each(batch_size: 250) do |te|
      te.update legacy: true
    end
  end

  def down
    remove_column :time_entries, :legacy
  end
  
end