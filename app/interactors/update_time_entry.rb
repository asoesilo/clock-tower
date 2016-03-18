class UpdateTimeEntry
  include Interactor

  def call
    unless required_params
      #add errors
      context.fail!
    end
    set_required_variables
    make_inital_changes

    if changes.present?
      project_changed if changes[:project_id]
      set_holiday if holiday_needs_update?
      set_rate if rate_needs_update?
    end

    @time_entry.save
    context.time_entry = @time_entry
  end

  private

  def changes
    @time_entry.changes
  end

  def project_changed
    if @project.location && @project.location != @time_entry.location
      set_location(@project.location)
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

  def make_inital_changes
    @time_entry.assign_attributes(time_entry_params)
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

end
