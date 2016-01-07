class TimeEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task

  validates :user, presence: true
  validates :project, presence: true
  validates :task, presence: true
  validates :entry_date, presence: true
  validates :duration_in_hours, presence: true

  before_save :set_rate

  def as_json(options)
    {
      id: id,
      user: user.as_json(options),
      project: project.as_json(options),
      task: task.as_json(options),
      date: entry_date,
      duration_in_hours: duration_in_hours,
      comments: comments
    }
  end

  class << self
    def query(from, to, user_ids = nil, project_ids = nil, task_ids = nil)
      result = TimeEntry.where("time_entries.entry_date >= ? AND time_entries.entry_date <= ?", from, to)

      if user_ids.present?
        result = result.where("time_entries.user_id = (?)", user_ids)
      end

      if project_ids.present?
        result = result.where("time_entries.project_id = (?)", project_ids)
      end

      if task_ids.present?
        result = result.where("time_entries.task_id = (?)", task_ids)
      end

      result.order(entry_date: :desc)
    end
  end

  private

  def set_rate()
    if user.secondary_rate? && task.apply_secondary_rate?
      rate = user.secondary_rate
    else
      rate = user.rate || 0
    end
    rate = (  entry_date.holiday?(:ca_bc) ? rate.to_f * user.holiday_rate_multiplier : rate.to_f)
    self.rate = rate
  end

end
