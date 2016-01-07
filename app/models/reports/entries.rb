class Reports::Entries

  attr_reader :holidays, :holiday_dates
  
  def initialize(from, to)
    @from = from
    @to = to
    @holidays = Holidays.between(@from, @to, :ca_bc)
    @holiday_dates = @holidays.collect { |h| h[:date] }
  end

  def holiday_entries_for(user, project_ids = nil, task_ids = nil)
    # no entries if no holidays in the time period
    return [] if holiday_dates.blank?
    
    entries = entries_for(user, project_ids, task_ids)
    entries = entries.where("time_entries.entry_date IN (?)", holiday_dates) 
    entries = entries.group(:entry_date).select(:entry_date)

    entries.collect do |e| 
      task = Task.find_by(id: e[:task_id])
      rate = e[:rate] || user.rate_for(task, true)
      {
        project_id: e[:project_id],
        task_id:    e[:task_id],
        hours:      e[:hours],
        holiday:    true,
        date:       e[:entry_date],
        project:    Project.find_by(id: e[:project_id]),
        task:       task,
        rate:       rate,
        cost:       e[:hours] * rate.to_f
      }
    end
  end

  def regular_entries_for(user, project_ids = nil, task_ids = nil)
    entries = entries_for(user, project_ids, task_ids)
    entries = entries.where("time_entries.entry_date NOT IN (?)", holiday_dates) if holiday_dates.present?
    
    entries.collect do |e|
      task = Task.find_by(id: e[:task_id])
      rate = e[:rate] || user.rate_for(task, false)
      {
        project_id: e[:project_id],
        task_id:    e[:task_id],
        hours:      e[:hours],
        holiday:    false,
        project:    Project.find_by(id: e[:project_id]),
        task:       task,
        rate:       rate,
        cost:       e[:hours] * rate.to_f
      }
    end
  end

  private

  def entries_for(user, project_ids = nil, task_ids = nil)
    entries = user.time_entries.where("time_entries.entry_date >= ? AND time_entries.entry_date <= ?", @from, @to)
    entries = entries.group(:project_id, :task_id, :rate)
    entries = entries.where(project_id: project_ids) if project_ids
    entries = entries.where(task_id: task_ids) if task_ids
    entries = entries.select("time_entries.rate, time_entries.project_id, time_entries.task_id, SUM(time_entries.duration_in_hours) AS hours")
  end

end
