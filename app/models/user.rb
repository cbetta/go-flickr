require "heroku"

class User < ActiveRecord::Base
  has_many :authentications
  has_many :photos
  
  def gowalla
    self.authentications.where(:provider => "gowalla").first
  end
  
  def flickr
    self.authentications.where(:provider => "flickr").first
  end
  
  def update_photos
    gowalla.api.user_photos(gowalla.username).each do |photo|
      p = Photo.find_or_create_by_url(photo.photo_urls.high_res_320x480)
      p.user = self
      p.save
      p.delay.upload(photo.spot)
    end
    nil
  end
  
  def self.update_all_photos
    User.all.each do |user|
      user.delay.update_photos
    end
    client = Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
    client.set_workers(ENV['HEROKU_APP'], 1)
    Delayed::Job.count
  end

end
