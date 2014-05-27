class SessionsController < ApplicationController
	
	def new 
	end

	def create
		email = params[:session][:email].downcase
		password = params[:session][:password]
		user = User.find_by_email(email)

		if user && user.authenticate(password)
			# sign in and redirect
			sign_in user
			redirect_back_or root_url
		else
			# show error and render form
			flash.now[:error] = "Invalid email/password combination"
			render "new"
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end

end
