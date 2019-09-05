class Email < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :emails_users
end
