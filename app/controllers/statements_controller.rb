class StatementsController < ApplicationController
  include StatementQueries

  before_action :load_statement, only: [:show]

  def index
    @statements = current_user.statements
  end

  def show
    @entries = entries_by_date @statement
  end

  private
  def load_statement
    @statement = current_user.statements.find(params[:id])
  end
end
