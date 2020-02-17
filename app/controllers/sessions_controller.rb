class SessionsController < ApplicationController

	skip_before_action :verify_logged_in, except: [:destroy]
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			if user.active
				session[:user_id] = user.id
				redirect_to root_path, success: "logged in successfully"
			else
				redirect_to root_path, danger: "Account not activated"
			end
		else
			redirect_to login_path, danger: "Invalid email or password"
		end		
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path, success: "logged out successfully"
	end
end
