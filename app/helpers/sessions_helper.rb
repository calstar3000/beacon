module SessionsHelper

	def sign_in(user)
		# create the token
		remember_token = User.new_remember_token
		# hash the token
		hashed_token = User.digest(remember_token)
		# store the token in a permanent cookie
		cookies.permanent[:remember_token] = remember_token
		# update the member's remember token with the hashed token
		user.update_attribute(:remember_token, hashed_token)
		# set the user to the current user, in case we ever want to sign in without a redirect
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		# get the remember token from the cookie
		cookie_remember_token = cookies[:remember_token]
		# hash it
		remember_token = User.digest(cookie_remember_token)
		# find the member using the token if one doesn't exist already
		@current_user ||= User.find_by_remember_token(remember_token)
	end

	def sign_out
		# create a new token
		remember_token = User.new_remember_token
		# hash the new token
		hashed_token = User.digest(remember_token)
		# update the member's token to the new one in case it has been stolen
		current_user.update_attribute(:remember_token, hashed_token)
		# delete the cookie
		cookies.delete(:remember_token)
		# set the current user to nothing, in case we ever want to sign out without a redirect
		self.current_user = nil
	end

end
