class Authentication < ActiveRecord::Base
  belongs_to :user
  
  def self.create_with_omniauth(auth, user)
    create! do |authentication|
      authentication.provider = auth["provider"]
      authentication.uid = auth["uid"]
      if authentication.user.nil? && user.nil?
        authentication.user = User.new
        authentication.user.name = auth["user_info"]["name"]
        authentication.user.save
      else
        authentication.user = user
      end
      authentication.save
    end
  end
  
  def api
    if provider == 'gowalla'
      Gowalla::Client.new ({
        :api_key     => ENV['GWPHOTOS_GOWALLA_KEY'],
        :api_secret  => ENV['GWPHOTOS_GOWALLA_SECRET'],
        :access_token => self.access_token
      })
    elsif provider == 'flickr'
    end
  end
  
end
