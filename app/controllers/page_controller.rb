class PageController < ApplicationController
	skip_before_action :verify_logged_in
	
	def home
	end
end
