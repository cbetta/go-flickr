class User < ActiveRecord::Base
  has_many :authentications
  
  def gowalla
    self.authentications.where(:provider => "gowalla").first
  end
  
  def flickr
    self.authentications.where(:provider => "flickr").first
  end
end
