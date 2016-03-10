class Statement < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries

  has_many :statement_transitions, autosave: false
  has_many :time_entries
  belongs_to :user

  validates :from, presence: true
  validates :to, presence: true
  validates :user_id, presence: true
  validates :subtotal, presence: true
  validates :tax_amount, presence: true
  validates :hours, presence: true
  validates :total, presence: true

  scope :by_users, -> (users){ where(user_id: users) }
  scope :containing_date, -> (date){ where("statements.from <= ? AND statements.to >= ?", date, date) }

  def state_machine
    @state_machine ||= StatementStateMachine.new(self, transition_class: StatementTransition)
  end

  def self.transition_class
    StatementTransition
  end

  def self.initial_state
    :pending
  end
end
