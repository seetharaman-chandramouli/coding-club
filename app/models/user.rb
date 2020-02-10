class User < ActiveRecord::Base

	has_many :questions

	validates :email, :presence => true, :uniqueness => true, format: { with: URI::MailTo::EMAIL_REGEXP }
	
	has_secure_password

	def full_name
		"#{first_name} #{last_name}"
	end

	def title
		admin? ? "Admin" : "User"
	end


end