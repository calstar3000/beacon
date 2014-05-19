class User < ActiveRecord::Base
	attr_accessible :email, :email_confirmation, :name

	has_many :statuses

	#validates_associated :statuses
	validates :name, :email, :email_confirmation, presence: true
	validates :name, :email, length: { in: 2..50 }
	validates :email, confirmation: true
	validates :email, uniqueness: true
end
