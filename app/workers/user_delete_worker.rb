class UserDeleteWorker
	include Sidekiq::Worker

  	def perform(user_id)
  		user = User.unscoped.find_by(id: user_id)
  		user.destroy if user.deleted?
  	end
end

# User table add deleted column - boolean default false - done
# Destroy action will update column instead of destroy - done
# Add deleted: false as a default scope in user model (User.all should not list deleted users) - done
# Add restore method to user controller (only for admin) - done
# Create job to destroy deleted user permanently