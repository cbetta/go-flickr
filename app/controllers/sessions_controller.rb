class SessionsController < ApplicationController
  
  def create
    # get the omniauth hash
    auth = request.env["omniauth.auth"]
    # if the provider is gowalla, log the user in
    if auth["provider"] == 'gowalla'
      authentication = Authentication.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Authentication.create_with_omniauth(auth)
      authentication.access_token = auth['credentials']['token']
      authentication.username = auth['user_info']['nickname']
      authentication.save 
    # if it's flickr and the user is logged in, bind flickr
    elsif auth["provider"] == 'flickr' && !current_user.nil?
      authentication = current_user.authentications.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Authentication.create_with_omniauth(auth)
    else
      redirect_to root_url, :notice => "Oops. Something went wrong"
    end
    
    
    session[:user_id] = authentication.user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
  
  def failure
    redirect_to root_url, :notice => "Oops. Something went wrong."
  end
end
