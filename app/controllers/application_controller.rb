class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?
  before_action :verify_logged_in
  
  add_flash_types :danger, :info, :warning, :success

  def current_user
  	@current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
  	current_user.present?
  end

  def verify_logged_in
    redirect_to root_path, danger:"Invalid operation" unless logged_in?
  end

end
