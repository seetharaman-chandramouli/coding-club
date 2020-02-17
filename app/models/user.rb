class User < ActiveRecord::Base

	before_destroy :check_admins_present, if: -> { self.admin? }
	has_many :following_relations, class_name: "Relationship" , foreign_key: "following_id", dependent: :destroy
	has_many :follower_relations, class_name: "Relationship" ,foreign_key: "follower_id", dependent: :destroy
	has_many :followings, through: :follower_relations
	has_many :followers, through: :following_relations
	has_many :questions, dependent: :destroy
	has_many :answers, dependent: :destroy
	has_many :answervotes
	scope :admin_count, -> { where(admin: true).count(:admin) }
	validates :email, :presence => true, :uniqueness => true, format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :mobile_number, :presence => true
	validates :age, :presence => true
	validates :batch, :presence => true
	validates :degree, :presence => true
	validates :college_name, :presence => true
	validates :register_number, :presence => true, :uniqueness => true
	validates :company_name, :presence => true
	validates :designation, :presence => true
	validates :location, :presence => true
	has_secure_password

	def full_name
		"#{first_name} #{last_name}"
	end

	def title
		admin? ? "Admin" : "User"
	end

	def status
		active? ? "Active" : "Deactive"
	end

	def check_admins_present
		self.errors.add(:base, "Atleast 1 admin must be present") and return false if User.admin_count == 1
	end

	

end