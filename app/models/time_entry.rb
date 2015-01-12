class TimeEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task

  validates :user, presence: true
  validates :project, presence: true
  validates :task, presence: true
  validates :entry_date, presence: true
  validates :duration_in_hours, presence: true

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
    def query(from, to, user_ids: nil, project_ids: nil, task_ids: nil)
      result = TimeEntry.where("time_entries.entry_date >= ? AND time_entries.entry_date <= ?", from, to)

      if user_ids && user_ids.size > 0
        result = result.where(user_id: user_ids)
      end

      if project_ids
        result = result.where(project_id: project_ids)
      end

      if task_ids
        result = result.where(task_id: task_ids)
      end

      result.order(entry_date: :desc)
    end
  end
end
