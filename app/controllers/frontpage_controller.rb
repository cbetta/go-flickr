class FrontpageController < ApplicationController
  
  def index
    logger.info gowalla.user_photos(current_user.gowalla.username).to_yaml if current_user
  end
end
