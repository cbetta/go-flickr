require 'net/http'

class Photo < ActiveRecord::Base
  belongs_to :user
  
  # 
  # Uploads the photos to flickr and marks the model as uploaded
  # 
  def upload
    FlickRaw.api_key=ENV['GWPHOTOS_FLICKR_KEY']
    FlickRaw.shared_secret=ENV['GWPHOTOS_FLICKR_SECRET']
    
    temp_filename = "#{Rails.root}/tmp/photo_#{self.id}.img"
    uri = Domainatrix.parse(self.url)
    
    Net::HTTP.start("static.gowalla.com") { |http|
      resp = http.get(uri.path)
      open(temp_filename, "wb") { |file|
        file.write(resp.body)
      }
    }
    
    flickr.auth.checkToken :auth_token => self.user.flickr.access_token
    flickr.upload_photo temp_filename
  end
end
