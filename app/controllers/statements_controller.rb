class StatementsController < ApplicationController
  include StatementQueries

  def index
    @statements = current_user.statements
  end

  def show
    @statement = current_user.statements.find(params[:id])
    @entries = entries_by_date @statement
  end

end
