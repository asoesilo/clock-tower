class StatementTimeEntry < ActiveRecord::Base
  belongs_to :time_entry
  belongs_to :statement

  validates :statement_id, presence: true
  validates :time_entry_id, presence: true
  validates :state, presence: true

  before_validation :set_default_state, on: :create

  def set_default_state
    self.state = Statement.initial_state
  end
end
