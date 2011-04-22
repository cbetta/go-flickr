class SessionsController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
      
    authentication = Authentication.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Authentication.create_with_omniauth(auth)
    authentication.access_token = auth['credentials']['token']
    authentication.username = auth['user_info']['nickname']
    authentication.save 
    
    
    session[:user_id] = authentication.user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
