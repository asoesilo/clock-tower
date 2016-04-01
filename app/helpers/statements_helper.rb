module StatementsHelper
  def statement_states_select
    StatementStateMachine.states.map do |state|
      [state.capitalize, state]
    end
  end
end
