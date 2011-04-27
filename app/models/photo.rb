require 'net/http'

class Photo < ActiveRecord::Base
  belongs_to :user
  
  # 
  # Uploads the photos to flickr and marks the model as uploaded
  # 
  def upload
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
    flickr.upload_photo temp_filename
    
    # set the upload to true
    uploaded = true
    save
    
    #delete the file
    File.delete(temp_filename)
  end
end
