class User < ActiveRecord::Base
  has_many :posts
  has_many :payments
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  has_and_belongs_to_many :events

  validates_uniqueness_of :email

  before_update :update_profile_img_url

  after_create :save_profile_img_url_after_create

  def update_profile_img_url
    if self.read_attribute(:profile_img_file_name).present?
      self.profile_img_url = self.profile_img.url(:square)
    elsif self.read_attribute(:uid).present?
      self.profile_img_url = Net::HTTP.get_response(URI("https://graph.facebook.com/#{self.read_attribute(:uid)}/picture?type=normal"))['location']
    else
      self.profile_img_url = self.profile_img.url(:square)
    end
  end

  def save_profile_img_url_after_create
    self.update_profile_img_url
    # If validation isn't turned off, the record does not get saved because "Email has already been taken"
    self.save(validate: false)
  end

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def should_generate_new_friendly_id?
    profile_name_changed? || first_name_changed? || last_name_changed? || super
  end

  def slug_candidates
      [
        :profile_name,
        :first_name,
        [:first_name, :last_name],
        [:first_name, :last_name, rand(36**10).to_s(36)]
      ]
    end

  has_attached_file :profile_img, styles: {
    thumb: '100x100>',
    square: '100x100#',
    medium: '300x300>'
  }, :default_url => ENV['BASE_URL'] + "/images/user/missing.png"

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :profile_img, :content_type => /\Aimage\/.*\Z/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def logged_out_after?(time)
    (last_sign_out_at.to_f * 1000) > time
  end

  # Follows a user.
  def follow(other_user)
    if !active_relationships.where(followed_id: other_user.id).where(follower_id: id).exists?
      active_relationships.create(followed_id: other_user.id)
    end
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
end
