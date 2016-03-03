class CreateStatement
  include Interactor

  def call
    context.fail! unless required_params?

  end

  private

  def required_params?
    context[:to] && context[:from] && context[:user]
  end
end
