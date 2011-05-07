require 'net/http'
require "heroku"

class Photo < ActiveRecord::Base
  belongs_to :user
  
  # 
  # Uploads the photos to flickr and marks the model as uploaded
  # 
  def upload(spot)
    begin
    # config flickr raw
      FlickRaw.api_key=ENV['GWPHOTOS_FLICKR_KEY']
      FlickRaw.shared_secret=ENV['GWPHOTOS_FLICKR_SECRET']
      flickr.auth.checkToken :auth_token => self.user.flickr.access_token
    
      # save the file temprarily locally
      temp_filename = "#{Rails.root}/tmp/go_flickr_photo_#{self.id}.img"
      uri = Domainatrix.parse(self.url)
      Net::HTTP.start("static.gowalla.com") { |http|
        resp = http.get(uri.path)
        open(temp_filename, "wb") { |file|
          file.write(resp.body)
        }
      }
    
      # upload the file from tmp folder
      # spot_data = gowalla.api.spot(spot.url.split("/").last)
      flickr.upload_photo temp_filename, :title => spot.name, :description => "Shared on Gowalla: http://gowalla.com#{spot.url}", :tags => 'gowalla'
    
      # set the upload to true
      self.uploaded = true
      self.processed = true
      self.save
    
      #delete the file
      File.delete(temp_filename)
    # if this didnt work, mark as processed but not uploaded
    rescue
      self.uploaded = false
      self.processed = true
      self.save
    end
    #check wether to stop the worker
    throttle_heroku
  end
  
  def throttle_heroku
    if Rails.env.production?
      client = Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
      to_be_uploaded_count = Photo.where(:processed => false).count
      
      if (to_be_uploaded_count == 0)
        client.set_workers(ENV['HEROKU_APP'], 0) 
      end
    end
  end
end
