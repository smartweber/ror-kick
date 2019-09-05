class Api::LikesController < Api::BaseController
  def index
  end

  def create
    if Like.where(object_type_id: params[:object_type_id]).where(object_id: params[:object_id]).where(user_id: @current_user.id).count == 0
      ActiveRecord::Base.transaction do
        @like = Like.new()
        @like.user_id = @current_user.id
        @like.object_type_id = params[:object_type_id]
        @like.object_id = params[:object_id]
        if @like.save!
          if params[:object_type_id] == 1
            Post.update_counters(params[:object_id], like_count: 1)
          elsif params[:object_type_id] == 2
            Comment.update_counters(params[:object_id], like_count: 1)
          end
        end
      end
    end
  end

  def destroy
    @like = Like.where(object_type_id: params[:object_type_id]).where(object_id: params[:object_id]).where(user_id: @current_user.id).first
    ActiveRecord::Base.transaction do
      if @like.destroy!
        if params[:object_type_id] == 1
          Post.update_counters(params[:object_id], like_count: -1)
        elsif params[:object_type_id] == 2
          Comment.update_counters(params[:object_id], like_count: -1)
        end
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end
end
