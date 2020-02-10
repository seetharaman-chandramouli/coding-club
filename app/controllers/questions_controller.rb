class QuestionsController < ApplicationController

	def index
			if current_user.active?
				@question = Question.all 
			else
				redirect_to root_path, danger:"Invalid operation"
			end
	end

	def new
		@question = Question.new
	end

	def create
		@question = Question.new(question_params)
		@question.user_id = current_user.id
		@question.save
		redirect_to questions_path, success: "Question created successfully"	
	end

	def edit
		@question = Question.find_by(id: params[:id])
		if session[:user_id] == @question.user_id 
			@question = Question.find_by(id: params[:id])
		else
			redirect_to questions_path, danger: "Question not found"
		end
	end

	def update
		@question = Question.find_by(id: params[:id])	
		if @question.update(question_params)
            redirect_to questions_path, success: "Updated successfully" 
        else
            render :edit
        end
	end


	private
	
	def question_params
		params.require(:question).permit(:question)
	end

end