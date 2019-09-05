class Api::RegistrationsController < Api::BaseController
  skip_before_action :authenticate_user_from_token!
  before_action :process_avatar, only: [:create, :update]

  def process_avatar
    if params && params[:profile_img_values].present?
      p "**********"
      json_data = JSON.parse(params[:profile_img_values])
      # p json_data['data'].split(',')[1]
      # p json_data['name']
      p "**********"
      data = StringIO.new(Base64.decode64(json_data['data'].split(',')[1]))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = json_data['name']
      # data.content_type = "image/jpeg" # json_data['type'] # params[:header_img][:_values]['type']
      p data
      params[:profile_img_values] = data
    end
  end

  def create
    params[:profile_img] = params[:profile_img_values]

    #this is passed in by dropzone but isn't in the User model
    params.delete :profile_img_values

    @user = User.new(user_params)
    if !user_params[:slug].blank?
      if User.where(slug: user_params[:slug]).count > 0
        render_error("This profile name is already in use.", 401)
        return
      end
      # The slug value is auto-generated and re-indexed from profile_name column
      @user.profile_name = user_params[:slug]
    end

    if @user.save
      @auth_token = jwt_token(@user)

      if Rails.env.production?
        SlackNotify.notification("New User! #{@user.first_name} #{@user.last_name}: #{ENV["BASE_URL"]}/#{@user.slug}")
        SendSms.send_sms("+14157809000", "New User! #{@user.first_name} #{@user.last_name}: #{ENV["BASE_URL"]}/#{@user.slug}")
      end

      @to_user = @user
      WelcomeMailer.welcome_email(@user, @to_user).deliver_later

    else
      puts "Could not create user: #{@user.errors.full_messages}"
      render_errors @user.errors, 422
    end
  end

  def facebook_login
    # process_avatar

    fbUser = params[:fb_user]
    p fbUser
    # Verify FB token by using it
    # Could do the debug_token endpoint, but need special token for that: https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow#checktoken
    # HTTParty.get("https://graph.facebook.com/debug_token?input_token=#{params[:fbtoken]}&access_token=").parsed_response
    begin
      @fbr = MiniFB.get(fbUser[:access_token], "me", {fields: 'id,name,email,first_name,last_name'.split(',')})
      puts "response #{@fbr.inspect}"
    rescue => ex
      puts "Error accessing Facebook: #{ex}"
      render_error ex.message, 401
      return
    end

    # check if exists
    puts "email: #{@fbr.email}"
    @user = User.find_by_email(@fbr.email)
    puts "USER: " + @user.inspect
    if @user
      @auth_token = jwt_token(@user)
      # Add FB information if this is the user's first time logging in with FB
      #
      # if @user.fb_access_token && @user.uid
      #   @auth_token = jwt_token(@user)
      # # User hasn't logged in with FB before
      # else
      #   @user.uid = @fbr.id
      #   @user.fb_access_token = fbUser[:access_token]
      #   if @user.save
      #     @auth_token = jwt_token(@user)
      #   else
      #     puts "Could not add FB info to existing user: #{@user.errors.full_messages}"
      #     render_errors(@user.errors, 400)
      #     return
      #   end
      # end
    else
      # New user, add
      puts "User not found, creating new user"
      @user = User.new({
        uid: @fbr.id, # would be nice if this were fb_id or something, easier to know what it is and can have other providers, not just facebook
        email: @fbr.email,
        first_name: @fbr.first_name,
        last_name: @fbr.last_name,
        fb_access_token: fbUser[:access_token],
        password: fbUser[:access_token][0..70] # required, max 72
        })
      if @user.save
        @auth_token = jwt_token(@user)
      else
        puts "Could not create user: #{@user.errors.full_messages}"
        render_errors(@user.errors, 400)
        return
      end
    end
    render action: 'create'
  end

  def reset_password_request
    @user = User.find_by_email(user_params[:email])

    if !@user.present?
      render json: @user, error: 'Email not found', status: 404
    elsif @user.errors.present?
      render_errors(@user.errors, 422)
    elsif @user.present?
      @user.send_reset_password_instructions
      render json: @user, status: 200
    end
  end

  def reset_password
    @user = User.with_reset_password_token(user_params[:reset_password_token])
    @user.reset_password(user_params[:password], user_params[:password_confirmation])
    if @user.save
      @auth_token = jwt_token(@user)
    else
      puts "Could not reset password: #{@user.errors.full_messages}"
      render_errors(@user.errors, 422)
    end
  rescue
    render status: 404
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :slug, :bio, :email, :mobile_number, :password, :password_confirmation, :reset_password_token, :profile_img, :profile_img_values)
  end
end
