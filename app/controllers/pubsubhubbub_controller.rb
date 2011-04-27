class PubsubhubbubController < ApplicationController
  def validate
    render :text => params['hub.challenge'], :layout => false
  end
end
