class AddRateToAllTimeEntries < ActiveRecord::Migration

  def up
    # This will call the before_save callbacks to set rate and holiday information on TimeEntry.
    # TimeEntry.update_all wouldnt work
    TimeEntry.find_each(batch_size: 250) do |te|
      te.update updated_at: Time.now
    end
  end

  def down
  end

end
