class Post < ActiveRecord::Base
	belongs_to :user
	belongs_to :event
  validates :body, presence: true
	has_many :comments, -> { where object_type_id: 1 }, foreign_key: "object_id"
end
