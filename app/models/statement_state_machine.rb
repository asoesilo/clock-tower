class StatementStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :locked
  state :void

  transition from: :pending,  to: [:locked, :void]
  transition from: :locked,  to: [:void]

end
