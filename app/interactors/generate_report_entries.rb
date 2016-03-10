class GenerateReportEntries
  include Interactor

  def call
    context.fail! unless has_required_feilds?

    context.holiday_entries = holiday_entries_for(context[:project_ids], context[:task_ids])
    context.regular_entries = regular_entries_for(context[:project_ids], context[:task_ids])
  end

  private

  def has_required_feilds?
    context[:to] && context[:from] && context[:user]
  end

  def holiday_entries_for(project_ids = nil, task_ids = nil)
    entries = entries_for(holiday_entries, project_ids, task_ids)
    entries = entries.select(:entry_date, :holiday_code).group(:entry_date, :holiday_code)

    entries.collect do |entry|
      map_entry(entry, true)
    end
  end

  def regular_entries_for(project_ids = nil, task_ids = nil)
    entries = entries_for(regular_entries, project_ids, task_ids)

    entries.collect do |entry|
      map_entry(entry, false)
    end
  end

  def map_entry(e, is_holiday)
    rate = e[:rate] if e.apply_rate?
    {
        project_id:   e[:project_id],
        task_id:      e[:task_id],
        hours:        e[:hours],
        holiday:      is_holiday,
        holiday_code: e.try(:holiday_code).try(:to_sym),
        date:         e.try(:entry_date),
        project:      Project.find_by(id: e[:project_id]),
        task:         Task.find_by(id: e[:task_id]),
        rate:         rate,
        cost:         e[:hours] * rate.to_f
      }
  end

  def entries_for(entries, project_ids = nil, task_ids = nil)
    entries = entries.where(project_id: project_ids) if project_ids
    entries = entries.where(task_id: task_ids) if task_ids

    entries = entries.group(:project_id, :task_id, :rate, :apply_rate)
    entries = entries.select("time_entries.rate, time_entries.apply_rate, time_entries.project_id, time_entries.task_id, SUM(time_entries.duration_in_hours) AS hours")
  end

  def regular_entries
    entries.where(is_holiday: false)
  end

  def holiday_entries
    entries.where(is_holiday: true)
  end

  def entries
    context[:user].time_entries.where("time_entries.entry_date >= ? AND time_entries.entry_date <= ?", context[:from], context[:to])
  end

end
