class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :logged_in?
  helper_method :gowalla

  private

  def current_user
    if session[:user_id]
      authentication = Authentication.find_by_provider_and_uid("gowalla", session[:user_id]) 
      authentication.nil? ? nil : authentication.user
    else
      nil
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def gowalla
    current_user.gowalla
  end
end
