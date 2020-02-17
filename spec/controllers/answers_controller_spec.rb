require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

	describe 'GET #new' do
		it 'shows answer form for corresponding question when user is logged in' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1= Question.create(user_id: user.id,question:  "this is a test question1")
			get :new, {question_id: question1.id}
			response.should render_template :new
			User.destroy_all
			Question.destroy_all
		end
	end

	describe 'create' do

		it 'should allow user to create an answer if question exists' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		post :create, {question_id:question1.id, answer:{:answer => "this is a check answer"}}
	   		expect(flash[:success]).to eq('Answer Posted successfully')
	   		expect(response).to redirect_to("/questions/#{question1.id}")
	   		Question.destroy_all
		    User.destroy_all
		    Answer.destroy_all
	   	end

	   	it 'should not allow user to create an answer if question does not exists' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		post :create, {question_id: 10000, answer:{:answer => "this is a check answer"}}
	   		expect(flash[:danger]).to eq('Invalid operation')
	   		expect(response).to redirect_to("/questions")
	   		Question.destroy_all
		    User.destroy_all
		    Answer.destroy_all
	   	end

	   	it 'should not allow user to create an answer if answer fields are empty' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		post :create, {question_id:question1.id, answer:{:answer => ""}}
	   		expect(flash[:danger]).to eq('check fields')
	   		expect(response).to render_template :new
	   		Question.destroy_all
		    User.destroy_all
		    Answer.destroy_all
	   	end
	end

	describe 'edit' do

		it 'should allow user to edit the answers which they have posted' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		answer1 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer")
	   		get :edit, {question_id: question1.id, id:answer1.id}
	       	Answer.destroy_all
	   		Question.destroy_all
		    User.destroy_all
		end

		it 'should not allow user to edit the answers which they did not posted' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		user.active = true
	   		user1.active = true
	   		user1.save
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		answer1 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer")
	   		answer2 = Answer.create(user_id: user1.id,ques_id: question1.id, answer: "this is a test answer by user 2")
	   		get :edit, id: answer2.id , question_id: question1.id
	       	expect(flash[:danger]).to eq('Answer not found')
	   		expect(response).to redirect_to("/questions/#{question1.id}")
	   		Question.destroy_all
		    User.destroy_all
		    Answer.destroy_all
		end

		it 'should not allow user to edit the answers when answer does not exist' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		answer1 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer")
	   		answer2 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer by user 2")
	   		get :edit, id: 10000 , question_id: question1.id
	       	expect(flash[:danger]).to eq('Answer not found')
	   		expect(response).to redirect_to("/questions/#{question1.id}")
	   		Question.destroy_all
		    User.destroy_all
		    Answer.destroy_all
		end
	end


	describe 'update' do

		it 'should allow users to modify the answers which they have posted' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		answer1 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer")
	   		answer2 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer by user 2")
	   		put :update, {question_id: question1.id,id: answer1.id, answer: {answer: "update check"}}
	   		answer1.reload
	   		expect(answer1.answer).to eq("update check")
	   		expect(flash[:success]).to eq('Updated successfully')
   			expect(response).to redirect_to("/questions/#{question1.id}")
   			Question.destroy_all
		    User.destroy_all
		    Answer.destroy_all
		end

		it 'should not create or update answers if answer fields are empty' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		answer1 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer")
	   		answer2 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer by user 2")
	   		put :update, {question_id: question1.id,id: answer1.id, answer: {answer: ""}}
	   		expect(flash[:danger]).to eq('check fields')
	   		expect(response).to render_template :new
	   		User.destroy_all
	   		Question.destroy_all
	   		Answer.destroy_all
		end
	end

	describe 'destroy' do

		it 'should delete answers which were posted by the corresponding user' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		answer1 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer")
	   		answer2 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer by user 2")
	   		delete :destroy, {id: answer1.id, question_id: question1.id}
	   		expect(Answer.find_by(answer: "this is a test answer")).to be_nil
	   		expect(flash[:success]).to eq('Deleted successfully')
	   		expect(response).to redirect_to("/questions/#{question1.id}")
	   		User.destroy_all
	   		Question.destroy_all
	   		Answer.destroy_all
		end

		it 'should not delete answers which were not posted by the corresponding user' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user1.id,question:  "this is a test question1")
	   		answer1 = Answer.create(user_id: user1.id,ques_id: question1.id, answer: "this is a test answer")
	   		answer2 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer by user 2")
	   		delete :destroy, {question_id: question1.id, id: answer1.id}
	   		expect(Answer.find_by(answer: "this is a test answer")).to be_present
	   		expect(flash[:danger]).to eq('Answer not found')
	   		expect(response).to redirect_to("/questions/#{question1.id}")
	   		User.destroy_all
	   		Question.destroy_all
	   		Answer.destroy_all
		end
	end

	describe 'toggle_like' do

		it 'should allow user to like answer if he/she did not like' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		answer1 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer")
	   		answer2 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer by user 2")
	   		post :toggle_like, {id: answer1.id}
	   		expect(Answervote.find_by(user_id: user.id, answer_id: answer1.id)).to be_present
	   		expect(response).to redirect_to("/questions/#{question1.id}")
	   		User.destroy_all
	   		Question.destroy_all
	   		Answer.destroy_all
   		end  

   		it 'should allow user to unlike answer if he/she has already liked' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.save
	   		session[:user_id] = user.id
	   		question1 = Question.create(user_id: user.id,question:  "this is a test question1")
	   		answer1 = Answer.create(user_id: session[:user_id],ques_id: question1.id, answer: "this is a test answer")
	   		Answervote.create(user_id: user.id, answer_id: answer1.id)
	   		post :toggle_like, {id: answer1.id}
	   		expect(Answervote.find_by(user_id: user.id, answer_id: answer1.id)).to be_nil
	   		expect(response).to redirect_to("/questions/#{question1.id}")
	   		User.destroy_all
	   		Question.destroy_all
	   		Answer.destroy_all
   		end  

	end




end
