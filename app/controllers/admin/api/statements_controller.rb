class Admin::Api::StatementsController < Admin::BaseController
  skip_before_filter :verify_authenticity_token
  
  def index
    statements = Statement.order(to: :asc)
    statements = statements.in_state(params[:state]) if params[:state]

    render json: statements
  end

  def update
    statement = Statement.find(params[:id])

    if statement.transition_to(params[:state])
      render json: statement, status: :ok
    else
      render json: { errors: 'Cannot transition to state' }, status: :bad_request
    end
  end
end
