class Api::TestingController < Api::BaseController
  skip_before_action :authenticate_user_from_token!

  # For testing errors
  def errors
    render_errors(["error 1", "error 2"])
  end
  def error
    render_error("this is an error")
  end
end
