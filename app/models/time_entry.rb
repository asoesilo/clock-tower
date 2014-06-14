class TimeEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task

  validates :user, presence: true
  validates :project, presence: true
  validates :task, presence: true
  validates :entry_date, presence: true
  validates :duration_in_hours, presence: true
end
