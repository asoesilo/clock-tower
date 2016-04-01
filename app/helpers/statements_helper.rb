module StatementsHelper
  def statement_states_select
    StatementStateMachine.states.map do |state|
      [state.capitalize, state]
    end
  end

  def valid_statement_states_select(statement)
    statement.state_machine.allowed_transitions.map do |state|
      [state.capitalize, state]
    end
  end
end
