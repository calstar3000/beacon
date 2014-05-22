class User < ActiveRecord::Base
	before_save { self.email = email.downcase }

	attr_accessible :email, :name, :password, :password_confirmation

	has_many :statuses

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
end
