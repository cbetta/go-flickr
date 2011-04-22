class User < ActiveRecord::Base
  has_many :authentications
  
  def gowalla
    self.authentications.where(:provider => "gowalla").first
  end
end
