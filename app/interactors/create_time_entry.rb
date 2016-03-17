class CreateTimeEntry
  include Interactor

  def call
    set_required_variables
    unless required_params?
      add_errors
      context.fail!
    end
    context.time_entry = TimeEntry.create!(time_entry_params)
  end

  private

  def required_params?
    @user.present? && @project.present? && @task.present? && @entry_date.present? && @duration_in_hours.present?
  end

  def add_errors
    errors = []
    errors << "User is required" if @user.blank?
    errors << "Project is required" if @project.blank?
    errors << "Task is required" if @task.blank?
    errors << "Entry Date is required" if @entry.blank?
    errors << "Duration is required" if @duration_in_hours.blank?
    context.errors = errors.join(', ')
  end

  def set_required_variables
    @user = context[:user]
    @project = Project.find_by(id: context[:project_id])
    @task = Task.find_by(id: context[:task_id])
    @entry_date = Date.parse(context[:entry_date])
    @duration_in_hours = context[:duration_in_hours]
  end

  def location
    @project.location || @user.location
  end

  def holiday_code
    location.try(:holiday_code) || :ca_bc
  end

  def is_holiday?
    @entry_date.holiday?(holiday_code)
  end

  def user_rate
    if @user.secondary_rate && @task.apply_secondary_rate?
      @user.secondary_rate
    else
      @user.rate
    end
  end

  def rate
    is_holiday? ? (user_rate.to_f * @user.holiday_rate_multiplier) : user_rate.to_f
  end

  def time_entry_params
    {
      user: @user,
      project: @project,
      task: @task,
      location: location,
      entry_date: @entry_date,
      duration_in_hours: @duration_in_hours,
      comments: context[:comments],
      rate: rate,
      apply_rate: @user.hourly?,
      is_holiday: is_holiday?,
      holiday_rate_multiplier: @user.holiday_rate_multiplier,
      holiday_code: holiday_code,
      has_tax: @user.has_tax?,
      tax_desc: location.try(:tax_name),
      tax_percent: location.try(:tax_percent)
    }
  end

end
