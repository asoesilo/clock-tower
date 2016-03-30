class StatementStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :locked
  state :void
  state :legacy

  transition from: :pending,  to: [:locked, :void, :legacy]
  transition from: :locked,  to: [:void]
  transition from: :legacy, to: [:void]

  after_transition(after_commit: true) do |statement, transition|
    statement.statement_time_entries.update_all state: transition.to_state
  end

end
