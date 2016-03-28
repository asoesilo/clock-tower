class UpdateTimeEntry
  include Interactor

  def call
    unless required_params
      set_errors
      context.fail!
    end
    set_required_variables
    make_inital_changes

    if changes.present?
      project_changed if changes[:project_id]
      check_statement_validity if changes[:entry_date]
      set_holiday if holiday_needs_update?
      set_rate if rate_needs_update?
    end

    if @time_entry.save
      context.time_entry = @time_entry
    else
      context.errors = @time_entry.errors.full_messages
      context.fail!
    end
  end

  private

  def changes
    @time_entry.previous_changes.merge(@time_entry.changes)
  end

  def project_changed
    if @project.location != @time_entry.location
      set_location(@project.location || @user.location)
    end
  end

  def holiday_needs_update?
    changes[:holiday_code] || changes[:entry_date]
  end

  def rate_needs_update?
    changes[:task_id] || changes[:is_holiday]
  end

  def set_required_variables
    @time_entry = context[:time_entry]
    @user = @time_entry.user
    @project = Project.find_by(id: context[:project_id])
    @task = Task.find_by(id: context[:task_id])
    @entry_date = Date.parse(context[:entry_date])
    @duration_in_hours = context[:duration_in_hours]
  end

  def set_errors
    errors = []
    errors << "Time Entry is required" if context[:time_entry].blank?
    errors << "Project is required" if context[:project_id].blank?
    errors << "Task is required" if context[:task_id].blank?
    errors << "Entry Date is required" if context[:entry_date].blank?
    errors << "Duration is required" if context[:duration_in_hours].blank?
    context.errors = errors.join(', ')
  end

  def make_inital_changes
    @time_entry.update(time_entry_params)
  end

  def required_params
    context[:time_entry].present? && context[:project_id].present? && context[:task_id].present? && context[:entry_date].present? && context[:duration_in_hours].present?
  end

  def time_entry_params
    {
      project: @project,
      task: @task,
      entry_date: @entry_date,
      duration_in_hours: @duration_in_hours,
      comments: context[:comments]
    }
  end

  def set_location(location)
    @time_entry.location = location
    @time_entry.holiday_code = location.holiday_code
    @time_entry.tax_percent = location.tax_percent
    @time_entry.tax_desc = location.tax_name
  end

  def set_rate
    @time_entry.rate = calculate_rate
  end

  def set_holiday
    @time_entry.is_holiday = @entry_date.holiday?(@time_entry.holiday_code)
  end

  def calculate_rate
    @time_entry.is_holiday? ? (user_rate.to_f * @user.holiday_rate_multiplier) : user_rate.to_f
  end

  def user_rate
    if @user.secondary_rate && @task.apply_secondary_rate?
      @user.secondary_rate
    else
      @user.rate
    end
  end

  def check_statement_validity
    if @time_entry.statement && !(@entry_date >= @time_entry.statement.from && @entry_date <= @time_entry.statement.to)
      @time_entry.statement = nil
    end
    if @time_entry.statement.blank?
      @time_entry.statement = Statement.in_state(:pending).where('statements.to > ?', @entry_date).take
    end
  end
end
