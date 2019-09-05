class Api::BaseController < ApplicationController
  include ActionController::ImplicitRender
  respond_to :json

  def get_user!
    user = claims.nil? ? nil : User.find_by(email: claims[0]['user'])
    @current_user = user
  end

  before_action :authenticate_user_from_token!

  protected

  def render_error(error, status=400)
     @error = error
     render '/api/error', status: status
  end

  # Pass in an ActiveRecord object after attempting to save.
  def render_errors(errors, status=400)
    if errors.is_a? ActiveRecord::Base
      @error = "Error saving #{errors.class.name}"
      @errors = errors.errors.full_messages
    elsif errors.is_a? Array
      @errors = errors
    else
      @errors = errors.full_messages
    end
    render '/api/errors', status: status
  end

  # Pass in an ActiveRecord object pre-save. This will call save on it and render errors if it fails.
  # Usage: `return unless save(obj)`
  def save(ob)
    if ob.save
      return true
    else
      puts "Error saving #{ob.class.name}: #{ob.errors.full_messages}"
      render_errors(ob)
    end
  end

  def destroy_obj(ob)
    if ob.destroy
      return true
    else
      puts "Error destroying #{ob.class.name}: #{ob.errors.full_messages}"
      render_errors(ob)
    end
  end

  def authenticate_user_from_token!
    return render_unauthorized if claims.nil?
    return render_unauthorized unless user = User.find_by(email: claims[0]['user'])
    return render_unauthorized if user.logged_out_after?(claims[0]['iat'])

    @current_user = user
  end

  def current_user
    @current_user
  end

  def claims
    auth_header = request.headers['Authorization'] and
      token = auth_header.split(' ').last and
      ::JsonWebToken.decode(token)
  rescue
    nil
  end

  def jwt_token(user)
    JsonWebToken.encode('user' => user.email)
  end

  def render_unauthorized(payload = { errors: { unauthorized: ["You are not authorized perform this action."] } })
    render_error 'Incorrect credentials', 401
  end
end
