class Resource < ApplicationRecord
  belongs_to :resource_type
  has_many :tier_resources
  has_many :tiers, :through=>:tier_resources
  has_many :resource_price_breaks
end
