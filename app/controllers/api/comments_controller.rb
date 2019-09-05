class Api::CommentsController < Api::BaseController
  def index
  end

  def create
    ActiveRecord::Base.transaction do
      @comment = Comment.new()
      @comment.user_id = @current_user.id
      @comment.object_type_id = params[:object_type_id]
      @comment.object_id = params[:object_id]
      @comment.body = params[:body]
      if @comment.save!
        if @comment.object_type_id == 1
          Post.update_counters(@comment.object_id, comment_count: 1)
          post = Post.find(@comment.object_id)
          post_user = post.user
          if post_user.id != @current_user.id
            event = post.event
            subject = "#{@current_user.first_name} replied to your post on KickParty"
            body = "#{@current_user.first_name} wrote a reply to your post on #{event.name}.  "\
                    "Click here to reply on the KickParty site: #{ENV['BASE_URL']}/events/#{event.slug}#post#{post.id}"
            GenericMailer.generic_email(post_user, body, subject).deliver_later
          end
        end
      end
    end
  end

  def destroy
  end
end
