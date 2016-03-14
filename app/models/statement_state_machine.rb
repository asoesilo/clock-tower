class StatementStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :locked

  transition from: :pending,  to: [:locked]

end
