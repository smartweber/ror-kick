class Event < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_many :events_users
	has_many :tiers
	has_many :emails
	has_many :posts
	belongs_to :event_type
	belongs_to :user, foreign_key: 'created_by'

	include ShortenerHelper

	searchkick locations: ["location"]

	def search_data
    {
      name: name,
      description: description,
			key: key,
			slug: slug,
			location: {lat: location_lat, lon: location_lng},
      created_by_first_name: user.first_name,
			created_by_last_name: user.last_name,
			created_by_id: user.id,
			attendees: users.map(&:id),
			deadline: deadline,
			start: start,
			status: status
    }
  end

	has_attached_file :header_img, styles: {
    thumb: '100x100>',
		wide_thumb: '190x95#',
		share_thumb: '200x200#',
    square: '370x230#',
    medium: '1600x800>'
  },	:default_url => "/images/event/missing.jpg"

	# Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :header_img, :content_type => /\Aimage\/.*\Z/

	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

	def slug_candidates
    [
      :name,
			[:name, :location_address],
			[:name, :location_address, :start]
    ]
  end

	def short_url_link
		if self.status == 1
			short_url("events/" + self.slug)
		else
			short_url("events/" + self.slug + "?key=" + (self.key || ""))
		end
	end

	def total_count
		events_users.count
	end

	def committed_count
		events_users.where(status: 1).count
	end

	def maybe_count
		events_users.where(status: 2).count
	end

	def payment_totals(processed, item_type)
		events_users
			.joins(:order => :order_items)
			.where(orders: {processed: processed})
			.where(order_items: {item_type: item_type})
			.sum(:cost).to_f
	end

	def isHost(user_id)
		host_count = events_users.where(user_id: user_id).where(relation: 1).count
		owner_count = self.created_by == user_id ? 1 : 0
		(host_count > 0 || owner_count > 0) ? true : false
	end

	def attendee_list(limit=nil, offset=0)
		users
		.select('users.*, events_users.id as event_user_id, events_users.relation, events_users.status')
		.order("events_users.relation DESC, events_users.status, events_users.id DESC")
		.limit(limit)
		.offset(offset)
	end

	validates :name, presence: { message: ' is required.' }
	validates :start, presence: { message: ' date and time is required.' }
	validates :event_type_id, presence: { message: ' is required.' }
	validates :location_address, presence: { message: ' is required.' }
	validates :description, length: { minimum: 6 }, allow_blank: true

	accepts_nested_attributes_for :tiers
end
