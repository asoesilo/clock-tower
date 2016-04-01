class StatementsController < ApplicationController
  include StatementQueries

  before_action :load_statement, only: [:show]

  def index
    @statements = current_user.statements.page(params[:page]).per(25).order(to: :desc)

    @statements = @statements.containing_date(params[:containing]) if params[:containing].present?
    @statements = @statements.in_state(params[:state]) if params[:state].present?
  end

  def show
    @entries = entries_by_date @statement
  end

  private
  def load_statement
    @statement = current_user.statements.find(params[:id])
  end
end
