class UsersController < ApplicationController

before_action :load_user, only: [:update, :activate, :activate_show, :destroy]

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
			if @user.save
				redirect_to root_path, success: "Account created successfully, wait till it gets activated"
			else
				redirect_to new_user_path, danger: "Mail id already taken"
				#render :partial => 'failure', danger: "Mail id already taken"
			end
	end

	def edit
		if session[:user_id] == params[:id].to_i
			load_user
		else
			redirect_to root_path, danger: "User not found"
		end 		
	end

	def update
		#@user = User.find_by(id: params[:id])
		if @user.update(user_params)
            redirect_to root_path, success: "Updated successfully" 
        else
            render :edit
        end
	end

	def index
		if current_user.admin?
			@user = User.all.order("admin DESC" ,"register_number")
		else
			redirect_to root_path
		end
	end

	def destroy
		if User.where(admin: true).count(:admin)>1
			#@user = User.find_by(id: params[:id])
			@user.destroy
        	redirect_to users_path, success: "Deleted successfully"
        else
        	redirect_to users_path, danger: "Atleast 1 admin must be present"
        end
	end

	def activate
		@user.update_attribute(:active, !@user.active)
		redirect_to users_path
	end

	def promote
		promote_revoke
		redirect_to users_path
	end

	def activate_show
		@user.update_attribute(:active, !@user.active)
		redirect_to user_path
	end

	def promote_show
		promote_revoke
		redirect_to user_path
	end

	def show
		if current_user.admin?
			load_user
		else
			redirect_to root_path
		end
	end




	private
	
	def user_params
		params.require(:user).permit(:first_name, :last_name, :mobile_number, :age, :batch, :degree, :college_name, :register_number, :company_name, :designation, :location, :email, :password)
	end

	def load_user
		@user = User.find_by(id: params[:id])
	end


	def promote_revoke
		@user = User.find_by(id: params[:id])
		if @user.admin == false
			@user.admin = true
			@user.active = true
		else
			@user.admin = false 
		end
		@user.save
	end





end
