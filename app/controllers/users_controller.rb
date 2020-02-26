class UsersController < ApplicationController

skip_before_action :verify_logged_in, only: [:new, :create]
before_action :load_user, only: [:update, :toggle_activation, :destroy, :toggle_promotion, :show, :profile_view]

	def new
		@user = User.new 
	end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to root_path, success: "Account created successfully, wait till it gets activated"
		else
			flash[:danger] = "check fields"
			render :new  

		end
	end

	def edit
		if current_user.id == params[:id].to_i
			load_user
		else
			redirect_to root_path, danger: "User not found"
		end 		
	end

	def update
		if @user.update(user_params)
            redirect_to root_path, success: "Updated successfully" 
        else
            render :edit
        end
	end

	def index 
		if current_user.admin?
			@user = User.unscoped.all.order("admin DESC" ,"register_number")
		else
			@user = User.all.where(active: true)
		end
	end

	def destroy 
		# if @user.update_attribute(:deleted, true)
		# 	UserDeleteWorker.perform_at(15.minutes.from_now, @user.id)
		# 	redirect_to users_path, success: "Deleted successfully"
		# else
		# 	redirect_to users_path, danger: @user.errors.messages.values.join('\n')
		# end
		if @user.destroy
			redirect_to users_path, success: "Deleted successfully"
		else
			redirect_to users_path, danger: @user.errors.messages.values.join('\n')
		end
	end

	# def restore
	# 	@user = User.unscoped.find_by(id: params[:id])
	# 	@user.update_attribute(:deleted, false)
	# 	redirect_to users_path, success: "Restored successfully"
	# end

	def toggle_activation
		@user.update_attribute(:active, !@user.active)
		redirect_to user_path
	end

	def toggle_promotion
		if @user.admin?
			@user.update_attribute(:admin, false)
		else
			@user.update({admin: true, active: true})
		end
		redirect_to user_path
	end

	def toggle_follow
		if @follow_check = Relationship.find_by(following_id: params[:id], follower_id: current_user.id)
			@follow_check.destroy
		else
			Relationship.create(following_id: params[:id], follower_id: current_user.id)
		end
		redirect_to user_path(params[:id])
	end

	def show
		if @user.present?
			@following =  @user.followings
			@follower =  @user.followers
		else
			redirect_to root_path, danger: "Invalid Operation"
		end
	end

	def profile_view
		if  current_user.id == params[:id].to_i
			@following =  @user.followings
			@follower =  @user.followers
		else
			redirect_to root_path, danger: "Invalid Operation"
		end
	end


	private
	
	def user_params
		params.require(:user).permit(:first_name, :last_name, :mobile_number, :age, :batch, :degree, :college_name, :register_number, :company_name, :designation, :location, :email, :password)
	end

	def load_user
		@user = User.find_by(id: params[:id])
	end
end
