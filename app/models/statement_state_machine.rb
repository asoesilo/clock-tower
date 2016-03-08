class StatementStateMachine
  include Statesman::Machine

  state :pending, initial: true

end
