class Tier < ApplicationRecord
  belongs_to :event
  has_many :tier_resources
  has_many :resources, :through => :tier_resources

  def tier_total_resources
    tier_resources.sum(:price) || 0
  end

  def tier_total_cost
    (base_cost || 0) + self.tier_total_resources - (contribution || 0)
  end

  def base_cost_per_attendee
    if calculation_method == 1
      base = self.tier_total_cost / min_attendee_count
      (base > 0) ? base.round(2) : 0
    else
      cost_per_attendee || 0
    end
  end

  def self.calc_service_charge_per_attendee(base_cost)
    if base_cost && base_cost > 0
      percent_service_fee = base_cost * Rails.application.config.service_charge_rate
      total_service_fee = (percent_service_fee > 1.00) ? percent_service_fee : 1.00
    else
      total_service_fee = 0
    end

    (total_service_fee).round(2)
  end

  def service_charge_per_attendee
    Tier.calc_service_charge_per_attendee(self.base_cost_per_attendee)
  end

  def total_cost_per_attendee
    self.base_cost_per_attendee + self.service_charge_per_attendee
  end

  accepts_nested_attributes_for :resources
end
