class TierResource < ApplicationRecord
  belongs_to :tier
  belongs_to :resource
end
