class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :param_missing_error

  private

  def param_missing_error
    head :unprocessable_entity
  end
end
