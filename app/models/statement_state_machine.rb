class StatementStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :locked
  state :paid
  state :void
  state :legacy

  transition from: :pending,  to: [:locked, :void, :legacy]
  transition from: :locked,  to: [:void, :paid]
  transition from: :legacy, to: [:void]
  transition from: :paid, to: [:void]

  after_transition(after_commit: true) do |statement, transition|
    statement.statement_time_entries.update_all state: transition.to_state
  end

  after_transition(to: :locked) do |statement|
    statement.touch(:locked_at)
  end

  after_transition(to: :paid) do |statement|
    statement.touch(:paid_at)
  end

  after_transition(to: :void) do |statement|
    statement.touch(:void_at)
  end

end
