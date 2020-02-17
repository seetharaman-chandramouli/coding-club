class Answer < ActiveRecord::Base

	belongs_to :question, foreign_key: :ques_id, inverse_of: :answers
	belongs_to :user, inverse_of: :answers
	has_many :answervotes, dependent: :destroy
	has_many :voters, through: :answervotes, source: :user
	validates :answer, :presence => true



	def author?(current_user)
		user_id == current_user.id
	end

	def voted?(current_user)
		voters.include?(current_user)
	end

end