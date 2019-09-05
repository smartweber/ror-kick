class EmailsUser < ApplicationRecord
  belongs_to :email
  belongs_to :user
end
