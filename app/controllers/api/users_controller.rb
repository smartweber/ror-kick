class Api::UsersController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:show, :check_slug, :check_email]
  before_action :process_avatar, only: [:patch]

  def show
    @show_user = User.friendly.find(params[:id])

    @current_user = get_user!

    followers_offset = params[:followers_offset] || 0
    followers_limit = params[:followers_limit] || 20
    followed_offset = params[:followed_offset] || 0
    followed_limit = params[:followed_limit] || 20
    id = @show_user.id

    @found_followers = Relationship.includes(:follower)
      .where(followed: id)
      .offset(followers_offset)
      .limit(followers_limit)
    @found_followed = Relationship.includes(:followed)
      .where(follower: id)
      .offset(followed_offset)
      .limit(followed_limit)

    if @current_user.present? && @show_user.id == @current_user.id
      @created_events = Event
          .where(created_by: @current_user.id)
          .order(:deadline)
      @attending_events = Event.joins(:events_users)
          .where("events_users.user_id = ?", @current_user.id)
          .order(:deadline)
    else

      if @current_user.present?
        @created_events = Event.joins("LEFT OUTER JOIN events_users AS attendees ON events.id = attendees.event_id")
          .where("events.status = 1 OR attendees.user_id = ?", @current_user.id)
          .where(created_by: @show_user.id)
          .order(:deadline)
          .distinct

        @attending_events = Event.joins("LEFT OUTER JOIN events_users AS attendees ON events.id = attendees.event_id")
          .where("(events.status = 1 OR attendees.user_id = ?) AND attendees.user_id = ?", @current_user.id, @show_user.id)
          .order(:deadline)
          .distinct

        @following = @current_user.following?(@show_user)

      else
        @created_events = Event.where(status: 1).where(created_by: @show_user.id)

        @attending_events = Event.joins(:events_users)
          .where(status: 1)
          .where("events_users.user_id = ?", @show_user.id)
          .order(:deadline)
      end

    end
  rescue ActiveRecord::RecordNotFound => e
    head :not_found

  end

  def patch
    unless @current_user
      render_error("You must be logged in to edit user information", 401)
      return
    end

    if params[:email]
      userWithEmail = User.where(email: params[:email]).first
      if userWithEmail.present? && userWithEmail.id != @current_user.id
        render_error("This email is already in use.", 401)
        return
      end
    end

    if user_params[:slug] && params[:slug] != @current_user[:slug]
      if User.where(slug: user_params[:slug]).count > 0
        render_error("This profile name is already in use.", 401)
        return
      end
    end

    if params[:first_name]
      if params[:first_name].length == 0
        if userWithEmail.id != @current_user.id
          render_error("First name cannot be blank.", 401)
          return
        end
      end
    end

    if params[:last_name]
      if params[:last_name].length == 0
        if userWithEmail.id != @current_user.id # <--- Ummm....?
          render_error("Last name cannot be blank.", 401)
          return
        end
      end
    end

    p "*** USER PARAMS ***"
    p user_params

    @current_user.assign_attributes(user_params)



    if params[:slug] && params[:slug] != @current_user[:slug]
      if User.where(slug: params[:slug]).where.not(id: @current_user.id).count > 0
        render_error("This profile name is already in use.", 401)
        @error_message = "This profile name is already in use."
        return
      end
      # The slug value is auto-generated and re-indexed from profile_name column
      @current_user.profile_name = params[:slug]
    end

    if params[:password][:password].present? && params[:password][:new_password].present? && params[:password][:new_password_confirmation].present?
      if @current_user.valid_password?(params[:password][:password])
         @current_user.reset_password(params[:password][:new_password], params[:password][:new_password_confirmation])
        if @current_user.save
          @auth_token = jwt_token(@current_user)
        else
          puts "Could not reset password: #{@current_user.errors.full_messages}"
          @error_message = "The new password and confirmation you entered are invalid"
        end
      else
        puts "The entered password is not correct. #{@current_user.errors.full_messages}"
        @error_message = "The current password you entered is not correct."
        render_error("The password you entered is not correct.", 422)
      end
    else
      if @current_user.save
        @auth_token = jwt_token(@current_user)
      else
        puts "Could not create user: #{@current_user.errors.full_messages}"
        @error_message = "Could not create user"
        render_errors @current_user.errors, 422
      end
    end

    if @error_message
      p "*** ERROR ***"
      p @error_message
    end
  end

  def update_fb_friends
    user_id = fb_friend_params[:user_id]
    current_friends = fb_friend_params[:friend_ids].to_set
    stored_friends = FbFriend.where(user_uid: user_id).pluck(:friend_uid).to_set

    # For current_friends - stored_friends, create new entries
    (current_friends - stored_friends).each do |added_friend_id|
      if User.exists?(uid: added_friend_id)
        FbFriend.create(user_uid: user_id, friend_uid: added_friend_id)
      end
    end

    # For stored_friends - current_friends, delete entries
    to_delete = (stored_friends - current_friends)
    unless to_delete.empty?
      FbFriend.where({user_uid: user_id, friend_uid: to_delete.to_a}).destroy_all
    end
  end

  def check_slug
    @current_user = get_user!
    if @current_user
      @count = User.where(slug: params[:slug]).where.not(id: @current_user.id).count
    else
      @count = User.where(slug: params[:slug]).count
    end
  end

  def check_email
    @current_user = get_user!
    if @current_user
      @count = User.where(email: params[:email]).where.not(id: @current_user.id).count
    else
      @count = User.where(email: params[:email]).count
    end
  end

  private

  # This function was copy/pasted from the registration controller. Place for
  # future refactor.
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

      params[:profile_img] = params[:profile_img_values]

      #this is passed in by dropzone but isn't in the User model
      params.delete :profile_img_values
    end
  end

  def user_params
    params.permit([:id, :first_name, :last_name, :slug, :email, :bio, :mobile_number, :profile_img])
  end

  def password_params(pw_params)
    pw_params.except([:password, :new_password, :new_password_confirmation])
  end

  def fb_friend_params
    params.permit([:user_id, :friend_ids => []])
  end
end
