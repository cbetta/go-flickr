require 'net/http'
require "heroku"

class Photo < ActiveRecord::Base
  belongs_to :user
  
  # 
  # Uploads the photos to flickr and marks the model as uploaded
  # 
  def upload(spot)
    # config flickr raw
    FlickRaw.api_key=ENV['GWPHOTOS_FLICKR_KEY']
    FlickRaw.shared_secret=ENV['GWPHOTOS_FLICKR_SECRET']
    flickr.auth.checkToken :auth_token => self.user.flickr.access_token
    
    # save the file temprarily locally
    temp_filename = "#{Rails.root}/tmp/photo_#{self.id}.img"
    uri = Domainatrix.parse(self.url)
    Net::HTTP.start("static.gowalla.com") { |http|
      resp = http.get(uri.path)
      open(temp_filename, "wb") { |file|
        file.write(resp.body)
      }
    }
    
    # upload the file from tmp folder
    flickr.upload_photo temp_filename, :title => spot.name, :description => "Shared on Gowalla: http://gowalla.com/#{spot.url}"
    
    # set the upload to true
    self.uploaded = true
    self.save
    
    #delete the file
    File.delete(temp_filename)
    #check wether to stop the worker
    throttle_heroku
  end
  
  def throttle_heroku
    if Rails.env.production?
      client = Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
      current = client.info(ENV['HEROKU_APP'])[:workers].to_i
      jobs_count = Delayed::Job.count
      
      if (jobs_count == 0)
        client.set_workers(ENV['HEROKU_APP'], 0) 
      end
    end
  end
end
