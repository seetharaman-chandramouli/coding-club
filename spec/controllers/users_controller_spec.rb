require 'rails_helper'

RSpec.describe UsersController, type: :controller do

	describe 'GET #new' do
		it 'show signup form' do
			get :new
				response.should render_template :new
		end
	end

	describe 'create' do
		# before(:each) do
		# 	User.destroy_all
		# end

		# it 'sample test case' do
		# 	# setting up data
		# 	# running controller action
		# 	# checking response
		# end

		# it 'should not log in for deactivated users' do
		# 	# setting up data
		# 	user = User.create(email: 'unknown@gmail.com', password: 'test1234')
		# 	user.active = false
		# 	user.save
		# 	# running controller action
		# 	params = {email: 'unknown@gmail.com', password: 'test1234'}
		# 	post :create, params
		# 	# checking response
		# 	expect flash to be "Account not activated"
		# 	expect redirect_to root
		# 	# clean up data
		# 	user.destroy
		# end
	   	it 'should successfully create new user' do
	         current_user_count = User.all.count
	         post :create, {:user => {:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678'}}
	         new_user_count = User.all.count
	   		 new_user_count.should be_eql current_user_count + 1
	   		 User.find_by(first_name: "user12").present?
	         expect(response).to redirect_to("/")
	         User.destroy_all
	   	end

	   	it 'should have unique email id' do
	   		User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		current_user_count = User.all.count
	        post :create, {:user => {:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678'}}
	        new_user_count = User.all.count
	        new_user_count.should be_eql current_user_count
	        expect(response).to render_template :new
	        User.destroy_all
	   	end

	   	it 'should not create user if user fields are empty' do
	   		current_user_count = User.all.count
	   		post :create, {:user => {:first_name => "",:last_name => "",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678'}}
	   		new_user_count = User.all.count
	   		new_user_count.should be_eql current_user_count
	   		expect(response).to render_template :new
	        User.destroy_all

	   	end
	end

	describe 'edit' do

      	it 'should render profile page' do
	        user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	        session[:user_id]=user.id
	        get :edit, id: user.id
	       	response.should render_template :edit
	       	User.destroy_all
   		end

   		it 'should not render profile page if session not set' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
   			get :edit, id: user.id
   			expect(flash[:danger]).to eq('Invalid operation')
   			expect(response).to redirect_to("/")
   			User.destroy_all
   		end

   		it 'should not render profile page if user does not exist' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
   			session[:user_id]=user.id
   			get :edit, id: 1000
   			expect(flash[:danger]).to eq('User not found')
   			expect(response).to redirect_to("/")
   			User.destroy_all
   		end
   	end

   	describe 'update' do

   		it 'should update existing user' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
   			session[:user_id]=user.id
   			put :update, {id: user.id, user: {first_name: "user13"}}
   			user.reload
   			expect(user.first_name).to eq("user13")
   			expect(flash[:success]).to eq('Updated successfully')
   			expect(response).to redirect_to("/")
   			User.destroy_all
   		end

   		it 'should not update existing user if users fields are empty' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
   			session[:user_id]=user.id
   			put :update, {id: user.id, user: {first_name: ""}}
   			expect(response).to render_template :edit
   			User.destroy_all
   		end

   		it 'should not update existing user if users email is changed and if its already existing' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
   			User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
   			session[:user_id]=user.id
   			put :update, {id: user.id, user: {email: "user13@gmail.com"}}
   			expect(response).to render_template :edit
   			User.destroy_all
   		end
   	end

   	describe 'index' do

   		it 'should display users in desc order by admin/user and sort by register number if admin sign in' do
	   		user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.admin = true
	   		user.save
	   		session[:user_id]=user.id
	   		load_all_users=User.all.order("admin DESC" ,"register_number")
	   		get :index
	   		assigns(:user).should == load_all_users
	   		User.destroy_all
   		end

   		it 'should display only active users if user sign in' do
	   		user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.admin = true
	   		user1.active = true
	   		user.save
	   		user1.save
	   		session[:user_id]=user1.id
	   		load_all_users= User.all.where(active: true)
	   		get :index
	   		assigns(:user).should == load_all_users
	   		User.destroy_all
   		end
   	end

   	describe 'destroy' do

   		it 'should destroy users if admin deletes it' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.admin = true
	   		user.save
	   		session[:user_id]=user.id
	   		delete :destroy, {id: user1.id} 
	   		expect(User.find_by(email: "user13@gmail.com")).to be_nil
	   		expect(response).to redirect_to("/users")
	   		User.destroy_all
	   	end

	   	it 'should destroy admin if another admin deletes it' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.admin = true
	   		user1.active = true
	   		user1.admin = true
	   		user.save
	   		session[:user_id]=user.id
	   		delete :destroy, {id: user1.id} 
	   		expect(User.find_by(email: "user13@gmail.com")).to be_nil
	   		expect(response).to redirect_to("/users")
	   		User.destroy_all
	   	end

	   	it 'should not destroy admin if admin deletes it' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user.active = true
	   		user.admin = true
	   		user.save
	   		session[:user_id]=user.id
	   		delete :destroy, {id: user.id} 
	   		expect(User.find_by(email: "user12@gmail.com")).to be_present
	   		expect(response).to redirect_to("/users")
	   		User.destroy_all
	   	end
   	end

   	describe 'toggle_activation' do

   		it 'should activate if existing account is deactive' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
   			session[:user_id]=user.id
   			post :toggle_activation, {id: user.id}
   			User.find_by(email: "user12@gmail.com").active.should == true
   			expect(response).to redirect_to("/users/#{assigns(:user).id}")
   			User.destroy_all
   		end

   		it 'should deactivate if existing account is active' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
   			user.active = true
   			user.save
   			session[:user_id]=user.id
   			post :toggle_activation, {id: user.id}
   			User.find_by(email: "user12@gmail.com").active.should == false
   			expect(response).to redirect_to("/users/#{assigns(:user).id}")
   			User.destroy_all
   		end
   	end

   	describe 'toggle_promotion' do

   		it 'should promote a user as admin if existing account is not' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
   			session[:user_id]=user.id
   			post :toggle_promotion, {id: user.id}
   			User.find_by(email: "user12@gmail.com").admin.should == true
   			expect(response).to redirect_to("/users/#{assigns(:user).id}")
   			User.destroy_all
   		end

   		it 'should revoke admin if existing account is admin' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
   			user.admin = true
   			user.save
   			session[:user_id]=user.id
   			post :toggle_promotion, {id: user.id}
   			User.find_by(email: "user12@gmail.com").admin.should == false
   			expect(response).to redirect_to("/users/#{assigns(:user).id}")
   			User.destroy_all
   		end
   	end

   	describe 'toggle_follow' do

   		it 'should allow user to follow another user if he/she is not following' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		session[:user_id] = user.id
	   		post :toggle_follow, {id: user1.id}
	   		expect(Relationship.find_by(following_id: user1.id, follower_id: user.id)).to be_present
	   		expect(response).to redirect_to("/users/#{user1.id}")
	   		User.destroy_all
   		end  

   		it 'should allow user to follow another user if he/she is not following' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		session[:user_id] = user.id
	   		Relationship.create(following_id: user1.id, follower_id: user.id)
	   		post :toggle_follow, {id: user1.id}
	   		expect(Relationship.find_by(following_id: user1.id, follower_id: user.id)).to be_nil
	   		expect(response).to redirect_to("/users/#{user1.id}")
	   		User.destroy_all
   		end  
   	end

   	describe 'show' do
   		
   		it 'should display another users profile' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		user1=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 90121000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416125001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user13@gmail.com",:password => '12345678')
	   		session[:user_id] = user.id
	   		load_all_user=User.find_by(id: user1.id)
	   		get :show, {id: user1.id}
	   		assigns(:user).should == load_all_user
	   		User.destroy_all
   		end

   		it 'should not display users profile if that user does not exist' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		session[:user_id] = user.id
	   		get :show, id: 10000
	   		expect(flash[:danger]).to eq('Invalid Operation')
	   		expect(response).to redirect_to("/")
	   		User.destroy_all
   		end
   	end

   	describe 'profile_view' do

   		it 'should display current users profile' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		session[:user_id] = user.id
	   		load_all_user=User.find_by(id: user.id)
	   		get :profile_view, {id: user.id}
	   		assigns(:user).should == load_all_user
	   		User.destroy_all
   		end

   		it 'should not display users profile if that user does not exist' do
   			user=User.create(:first_name => "user12",:last_name => "user12",:mobile_number => 9000000001,:age => 21,:batch => "2016-2020",:degree => "IT",:college_name => "SJIT",:register_number => 312416205001,:company_name => "FRESHWORKS",:designation => "INTERN",:location => "Chennai",:email => "user12@gmail.com",:password => '12345678')
	   		session[:user_id] = user.id
	   		get :profile_view, id: 10000
	   		expect(flash[:danger]).to eq('Invalid Operation')
	   		expect(response).to redirect_to("/")
	   		User.destroy_all
   		end
   	end
end
