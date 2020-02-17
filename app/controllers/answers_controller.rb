class AnswersController < ApplicationController

	before_action :load_question, only: [:new, :edit, :destroy, :create]
	before_action :load_answer, only: [:edit, :update, :destroy, :toggle_like]

	def new
		@answer = @question.answers.new
	end

	def create
			@answer = @question.answers.new(answer_params)
			@answer.user_id = current_user.id
			if @answer.save
				redirect_to question_path(@question), success: "Answer Posted successfully"	
			else
				flash[:danger] = "check fields"
            	render :new
       		end
	end

	def edit
		if @answer.present?
			redirect_to question_path(@answer.ques_id), danger: "Answer not found" unless @answer.author?(current_user)
		else
			redirect_to question_path(params[:question_id]), danger: "Answer not found"
		end
	end

	def update	
		if @answer.update(answer_params)
            redirect_to question_path(@answer.ques_id), success: "Updated successfully" 
        else
        	flash[:danger] = "check fields"
            render :new
        end
	end

	def destroy
		if @answer.author?(current_user)
			@answer.destroy
			redirect_to question_path(@answer.ques_id), success: "Deleted successfully"
        else
        	redirect_to question_path(@answer.ques_id), danger: "Answer not found"
        end
	end

	def toggle_like
		voted = @answer.voters.include?(current_user)
		if voted
			@answer.answervotes.find_by(user_id: current_user.id).destroy
		else
			@answer.answervotes.create(user_id: current_user.id)
		end
		redirect_to question_path(@answer.ques_id)
	end

	private
	
	def answer_params
		params.require(:answer).permit(:answer)
	end

	def load_question
		@question = Question.find_by(id: params[:question_id])
		unless @question.present?
			redirect_to questions_path, danger: "Invalid operation"
		end

	end

	def load_answer
		@answer = Answer.find_by(id: params[:id])
	end
end