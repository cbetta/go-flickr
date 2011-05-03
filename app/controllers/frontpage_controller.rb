class FrontpageController < ApplicationController
  
  def index
  end
  
  #
  # Disables the user's account
  #
  def disable
    user = current_user
    # throw away the flickr authentication
    user.flickr.delete unless current_user.flickr.nil?
    # disable the account
    user.disabled = true
    user.fully_authorised = false
    user.save

    # now logout the user
    redirect_to root_url, :notice => "We have stopped auto-uploading photos for you. "
  end
  
  #
  #  Processes the backlog of a user on demand
  #
  def process_backlog
    current_user.delay.update_photos
    redirect_to root_url, :notice => "Your current Gowalla photos are now being uploaded"
  end
end
