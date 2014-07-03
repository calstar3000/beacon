class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	before_create :create_remember_token

	attr_accessible :email, :name, :password, :password_confirmation, :admin

	has_many :statuses, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	#validates_associated :statuses
	validates :name, 	presence: true, 
										length: { in: 2..50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: 	true, 
  									format: 		{ with: VALID_EMAIL_REGEX }, 
  									length: 		{ in: 2..50 }, 
  									uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 6 }

	def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def status_feed
    Status.where("user_id = ?", id)
  end

  def following?(other_user)
  	self.relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
  	self.relationships.find_by_followed_id(other_user.id).destroy
  end

  def status_feed
    Status.from_users_followed_by(self)
  end

	private
		def create_remember_token
			token = User.new_remember_token
			digest = User.digest(token)
			self.remember_token = digest
		end
end
