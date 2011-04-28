require "openssl"
require "heroku"

class SessionsController < ApplicationController
  
  def create
    # get the omniauth hash
    auth = request.env["omniauth.auth"]
    # if the provider is gowalla, log the user in
    if auth["provider"] == 'gowalla'
      authentication = Authentication.find_by_provider_and_uid(auth["provider"], auth["uid"], nil) || Authentication.create_with_omniauth(auth, nil)
      authentication.access_token = auth['credentials']['token']
      authentication.username = auth['user_info']['nickname']
      authentication.save 
      session[:user_id] = authentication.uid
      redirect_to root_url, :notice => "Signed in!"
    # if it's flickr and the user is logged in, bind flickr
    elsif auth["provider"] == 'flickr' && !current_user.nil?
      authentication =  Authentication.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Authentication.create_with_omniauth(auth, current_user)
      authentication.access_token = auth['credentials']['token']
      authentication.save
      authentication.user.fully_authorised = true
      authentication.user.save
      authentication.user.delay.update_photos
      if Rails.env.production?
        client = Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
        client.set_workers(ENV['HEROKU_APP'], 1)
      end
      redirect_to root_url, :notice => "Your Flickr account has now been associated and we have started to uplaod your photos to Flickr"
    else
      redirect_to root_url, :notice => "Oops. Something went wrong"
    end
    
    
    
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
  
  def failure
    redirect_to root_url, :notice => "Oops. Something went wrong."
  end
end
