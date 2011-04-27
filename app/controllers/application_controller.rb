class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :logged_in?
  helper_method :gowalla

  private

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    current_user.nil?
  end
  
  def gowalla
    Gowalla::Client.new ({
      :api_key     => ENV['GWPHOTOS_GOWALLA_KEY'],
      :api_secret  => ENV['GWPHOTOS_GOWALLA_SECRET'],
      :access_token => current_user.nil? ? current_user.gowalla.access_token : nil
    })
  end
end
