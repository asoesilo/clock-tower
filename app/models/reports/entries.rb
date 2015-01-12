class Reports::Entries

  attr_reader :holidays, :holiday_dates
  
  def initialize(from, to)
    @from = from
    @to = to
    @holidays = Holidays.between(@from, @to, :ca_bc)
    @holiday_dates = @holidays.collect { |h| h[:date] }
  end

  def holiday_entries_for(user)
    entries(user).
      where("time_entries.entry_date IN (?)", holiday_dates).
      group(:entry_date).
      select(:entry_date).collect do |e| 
        {
          project_id: e[:project_id],
          task_id:    e[:task_id],
          hours:      e[:hours],
          holiday:    true,
          date:       e[:entry_date]
        }
      end
  end

  def regular_entries_for(user)
    entries(user).
      where("time_entries.entry_date NOT IN (?)", holiday_dates).collect do |e|
        {
          project_id: e[:project_id],
          task_id:    e[:task_id],
          hours:      e[:hours],
          holiday:    false   
        }
      end
  end

  private

  def entries(user)
    entries = user.time_entries.where("time_entries.entry_date >= ? AND time_entries.entry_date <= ?", @from, @to)
    entries = entries.group(:project_id, :task_id)
    entries = entries.select("time_entries.project_id, time_entries.task_id, SUM(time_entries.duration_in_hours) AS hours")
  end

end
