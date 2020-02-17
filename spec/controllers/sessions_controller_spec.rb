require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

	describe 'create' do

		it 'should allow users to login if account is active' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
			user.active = true
			user.save
			post :create, {session: {email: "user12@gmail.com", password: "12345678"}}
			expect(flash[:success]).to eq('logged in successfully')
			expect(response).to redirect_to("/")
			User.destroy_all
		end

		it 'should allow users to login if account is not active' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
			post :create, {session: {email: "user12@gmail.com", password: "12345678"}}
			expect(flash[:danger]).to eq('Account not activated')
			expect(response).to redirect_to("/")
			User.destroy_all
		end

		it 'should allow users to login if credentials are not proper' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
			post :create, {session: {email: "user13@gmail.com", password: "123456789"}}
			expect(flash[:danger]).to eq('Invalid email or password')
			expect(response).to redirect_to("/login")
			User.destroy_all
		end

	end

	describe 'destroy' do
		
		it 'should allow user to logout and make his session as nil' do
			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
			user.active = true
			user.save
			post :create, {session: {email: "user12@gmail.com", password: "12345678"}}
			delete :destroy
			expect(session[:user_id]).to be_nil
			expect(flash[:success]).to eq('logged out successfully')
			expect(response).to redirect_to("/")
			User.destroy_all
		end
	end
end
