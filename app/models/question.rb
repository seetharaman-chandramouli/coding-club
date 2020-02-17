class Question < ActiveRecord::Base

	belongs_to :user, inverse_of: :questions
	has_many :answers, foreign_key: :ques_id, dependent: :destroy
	validates :question, :presence => true

	def author?(current_user)
		user_id == current_user.id
	end

end