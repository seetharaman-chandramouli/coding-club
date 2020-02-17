require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

	describe 'index' do
		
		it 'should display all the questions if user is logged in' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		question2 = Question.create(user_id: user.id,question:  "this is a test question2")
	   		load_all_question = Question.all.includes(:user).order("created_at DESC")
	   		get :index
	   		assigns(:question).should == load_all_question
	   		User.destroy_all
	   		Question.destroy_all
		end

		it 'should display the questions if user is not logged in' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		question2 = Question.create(user_id: user.id,question:  "this is a test question2")
	   		get :index
	   		expect(flash[:danger]).to eq('Invalid operation')
	   		expect(response).to redirect_to("/")
	   		User.destroy_all
	   		Question.destroy_all
		end
	end

	describe 'GET #new' do
		it 'shows question form when user is logged in' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
			get :new
			response.should render_template :new
			User.destroy_all
		end
	end


	describe 'create' do

		it 'should allow users to create questions if they are logged in' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		current_ques_count = Question.all.count
	   		post :create, {question:{:question => "this is a check question?"}}
	   		new_ques_count = Question.all.count
	   		new_ques_count.should be_eql current_ques_count + 1
	   		check_question = Question.find_by(question: "this is a check question?")
	   		check_question.present?
	   		expect(response).to redirect_to("/questions/#{check_question.id}")
		    Question.destroy_all
		    User.destroy_all
		end

		it 'should not create questions if question fields are empty' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		post :create, {question:{:question => ""}}
	   		expect(flash[:danger]).to eq('check fields')
	   		expect(response).to render_template :new
	   		User.destroy_all
	   		Question.destroy_all
		end
	end

	describe 'edit' do

		it 'should allow user to edit the questions which they have posted' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		question2 = Question.create(user_id: user.id,question:  "this is a test question2")
	   		get :edit, id: question1.id
	       	response.should render_template :edit
	   		Question.destroy_all
		    User.destroy_all
		end

		it 'should not allow user to edit the questions which they did not posted' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		user.active = true
	   		user1.active = true
	   		user1.save
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		question2 = Question.create(user_id: user1.id,question:  "this is a test question2")
	   		get :edit, id: question2.id
	       	expect(flash[:danger]).to eq('Question not found')
	   		expect(response).to redirect_to("/questions")
	   		Question.destroy_all
		    User.destroy_all
		end
	end

	describe 'update' do

		it 'should allow users to modify the questions which they have posted' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		question2 = Question.create(user_id: user.id,question:  "this is a test question2")
	   		put :update, {id: question1.id, question: {question: "update check"}}
	   		question1.reload
	   		expect(question1.question).to eq("update check")
	   		expect(flash[:success]).to eq('Updated successfully')
   			expect(response).to redirect_to("/questions")
   			Question.destroy_all
		    User.destroy_all
		end

		it 'should not create or update question if question fields are empty' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		put :update, {id: question1.id, question: {question: ""}}
	   		expect(flash[:danger]).to eq('check fields')
	   		expect(response).to render_template :new
	   		User.destroy_all
	   		Question.destroy_all
		end
	end

	describe 'show' do

		it 'should display answers for corresponding question if user is logged in' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		answer1 = question1.answers.create(user_id: user.id,answer: "this is a test answer")
	   		answer1.vote_count = 1
	   		question1.save
	   		load_all_answers = question1.answers.includes(:user, :voters).order("vote_count DESC")
	   		get :show, {id: question1.id}
	   		assigns(:answer).should == load_all_answers
	   		User.destroy_all
	   		Answer.destroy_all
	   		Question.destroy_all
		end

		it 'should not display answers if question is not found' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		get :show, {id: 10000000}
	   		expect(flash[:danger]).to eq('Invalid operation')
	   		expect(response).to redirect_to("/questions")
	   		User.destroy_all
	   		Answer.destroy_all
	   		Question.destroy_all
		end
	end

	describe 'destroy' do

		it 'should delete questions which were posted by the corresponding user' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		question2 = Question.create(user_id: user.id,question:  "this is a test question2")
	   		delete :destroy, {id: question1.id}
	   		expect(Question.find_by(question: "this is a test question1")).to be_nil
	   		expect(flash[:success]).to eq('Deleted successfully')
	   		expect(response).to redirect_to("/questions")
		end

		it 'should not delete questions which were not posted by the corresponding user' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user1.id,question:  "this is a test question1")
	   		question2 = Question.create(user_id: user.id,question:  "this is a test question2")
	   		delete :destroy, {id: question1.id}
	   		expect(Question.find_by(question: "this is a test question1")).to be_present
	   		expect(flash[:danger]).to eq('Question not found')
	   		expect(response).to redirect_to("/questions")
		end
	end
end
