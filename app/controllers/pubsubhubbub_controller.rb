class PubsubhubbubController < ApplicationController
  def validate
    render :text => params['hub.callback']
  end
end
