class Api::PostsController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:index]

  def index
    event = Event.friendly.find(params[:id])
    @current_user = get_user!
    if @current_user.present?
      # include like data for each post (and add comments)
      @posts = Post.joins("INNER JOIN users on users.id = posts.user_id")
                    .joins("LEFT OUTER JOIN likes ON likes.object_id = posts.id AND likes.user_id = #{@current_user.id} AND likes.object_type_id = 1")
                    .includes("comments")
                    .where("posts.event_id = #{event.id}")
                    .order("pinned DESC, posts.created_at DESC")
                    .select("posts.*, users.first_name AS user_first_name, users.last_name AS user_last_name, users.email AS user_email, users.slug AS user_slug, users.profile_img_url AS user_profile_img_url, users.uid AS user_uid, likes.id AS like")
    else
      # just send the posts & comments
      @posts = Post.joins("INNER JOIN users on users.id = posts.user_id")
                    .includes("comments")
                    .where("posts.event_id = #{event.id}")
                    .order("pinned DESC, posts.created_at DESC")
                    .select("posts.*, users.first_name AS user_first_name, users.last_name AS user_last_name, users.email AS user_email, users.slug AS user_slug, users.profile_img_url AS user_profile_img_url, users.uid AS user_uid, NULL as like")
    end

  rescue ActiveRecord::RecordNotFound => e
    head :not_found

  end

  def create
    #@post = Post.new(post_params)
    @post = Post.new
    @post.body = params[:post][:body]
    @post.pinned = params[:post][:pinned]
    @post.event_id = Event.friendly.find(params[:post][:event_id]).id
    @post.user = @current_user
    @post.save!
    begin
      # Rescuing this so users don't see that J forgot to pay the bills. ;)
      SendSms.send_sms("+14157809000", "New Message on KickParty! #{@current_user.first_name} #{@current_user.last_name} wrote: #{@post.body}")
      if @post.event_id == 1
        SendSms.send_sms("+13104672160", "New Message on KickParty! #{@current_user.first_name} #{@current_user.last_name} wrote: #{@post.body}")
      end
    rescue => ex
      puts "Error sending SMS, ignoring... #{ex}"
    end
  end

  private

  def post_params
    p params.inspect
    params.require(:post).permit(:id, :pinned, :title, :body, :event_id, :user_id)
  end
end
