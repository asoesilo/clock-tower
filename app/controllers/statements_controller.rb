class StatementsController < ApplicationController

  def index
    @statements = current_user.statements
  end

  def show
    @statement = current_user.statements.find(params[:id])
  end

end