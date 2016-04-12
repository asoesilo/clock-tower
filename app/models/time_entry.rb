class TimeEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task
  has_many :statement_time_entries
  has_many :statements, through: :statement_time_entries
  belongs_to :location

  validates :user, presence: true
  validates :project, presence: true
  validates :task, presence: true
  validates :comments, length: { maximum: 255, allow_nil: true }
  validates :entry_date, presence: true
  validates :duration_in_hours, numericality: { greater_than_or_equal_to: 0, less_than: 1000 }

  validate :statement_editable?
  before_destroy :can_destroy?

  scope :between, -> (from, to) { where('time_entries.entry_date BETWEEN ? AND ?', from.beginning_of_day, to.end_of_day) }
  scope :before, -> (date) { where('time_entries.entry_date < ?', date) }

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
        result = result.where(user_id: user_ids)
      end

      if project_ids.present?
        result = result.where(project_id: project_ids)
      end

      if task_ids.present?
        result = result.where(task_id: task_ids)
      end

      result.order(entry_date: :desc)
    end

    def with_no_statement
      joins("LEFT OUTER JOIN statement_time_entries ON time_entries.id = statement_time_entries.time_entry_id AND statement_time_entries.state != 'void'")
        .group('time_entries.id')
        .having('COUNT( statement_time_entries.id ) = 0')
    end
  end

  def editable?
    statements.not_in_state(Statement.editable_states).blank?
  end

  def statement
    statements.not_in_state('void').take
  end

  private

  def can_destroy?
    if editable?
      true
    else
      errors.add(:statement, 'is locked.')
      false
    end
  end

  def statement_editable?
    unless editable?
      errors.add(:statement, 'is locked.')
    end
  end
end
