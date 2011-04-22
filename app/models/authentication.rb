class Authentication < ActiveRecord::Base
  belongs_to :user
  
  def self.create_with_omniauth(auth)
    create! do |authentication|
      authentication.provider = auth["provider"]
      authentication.uid = auth["uid"]
      authentication.user = User.new
      authentication.user.name = auth["user_info"]["name"]
      authentication.user.save
      authentication.save
    end
  end
  
end
