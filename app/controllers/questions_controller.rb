class QuestionsController < ApplicationController

	before_action :load_question, only: [:index, :edit, :update, :destroy, :show]

	def index
		if Question.all.present?
			followers_user_id = current_user.followings.order("first_name, last_name").map(&:id)
			@question = Question.joins(:user).includes(:user)
			all_user_id = @question.order("users.first_name, users.last_name").map(&:user_id)
			order_users = followers_user_id | all_user_id
			@question = @question.order("FIELD(user_id, #{order_users.join(',')})")
		else
			flash[:danger] = "No Questions to load add a new one"
			@question = Question.new
			render :new
		end
	end

	def new
		@question = Question.new
	end

	def create
		@question = Question.new(question_params)
		@question.user = current_user
		if @question.save
			redirect_to question_path(@question.id), success: "Question created successfully"	
		else
			flash[:danger] = "check fields"
            render :new
        end
	end

	def edit
		redirect_to questions_path, danger: "Question not found" unless @question.present? && @question.author?(current_user)
	end

	def update	
		if @question.update(question_params)
            redirect_to questions_path, success: "Updated successfully" 
        else
        	flash[:danger] = "check fields"
            render :new
        end
	end

	def show
		# @answer = Answer.order("vote_count DESC").where("ques_id = ?", params[:id])
		if @question.present?
			@answer = @question.answers.joins(:user).includes(:voters).order("vote_count DESC")
		else
			redirect_to questions_path, danger: "Invalid operation"
		end
	end

	def destroy
		if @question.author?(current_user)
			@question.destroy
			redirect_to questions_path, success: "Deleted successfully"
        else
        	redirect_to questions_path, danger: "Question not found"
        end
	end

	private
	
	def question_params
		params.require(:question).permit(:question)
	end

	def load_question
		@question= Question.find_by(id: params[:id])
	end

end