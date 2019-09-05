class Api::RelationshipsController < Api::BaseController
    def create
      id = params[:followed_id]
      user = User.find(id)
      current_user.follow(user)

      @found_followers = Relationship.includes(:follower).where(followed: id).limit(20)
      @found_followed = Relationship.includes(:followed).where(follower: id).limit(20)
    end

    def destroy
        user = User.find(params[:id])
        current_user.unfollow(user)

        id = params[:id]
        @found_followers = Relationship.includes(:follower).where(followed: id).limit(20)
        @found_followed = Relationship.includes(:followed).where(follower: id).limit(20)
    end

end
