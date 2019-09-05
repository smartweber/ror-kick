class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :object_type
  has_many :likes, -> { where object_type_id: 2 }, foreign_key: "object_id"

  def get_like_id(user_id)
    likes.select(:id).where(user_id: user_id).first
  end
end
