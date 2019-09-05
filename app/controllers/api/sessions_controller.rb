class Api::SessionsController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:create, :current_sesssion]

  def create
    @user = User.find_for_database_authentication(email: user_params[:email])
    return invalid_login_attempt unless @user
    return invalid_login_attempt unless @user.valid_password?(user_params[:password])
    @auth_token = jwt_token(@user)
  end

  def destroy
    @current_user.update last_sign_out_at: Time.now
    @message = {logged_out: true}
    render @message, status: 200
  end

  def current_session
    authenticate_user_from_token!
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def invalid_login_attempt
    render_error 'Incorrect credentials', 401
  end
end
