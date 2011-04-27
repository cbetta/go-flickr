Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gowalla, ENV['GWPHOTOS_GOWALLA_KEY'], ENV['GWPHOTOS_GOWALLA_SECRET'], :disable_ssl_verification => true
  provider :flickr, ENV['GWPHOTOS_FLICKR_KEY'], ENV['GWPHOTOS_FLICKR_SECRET'], :scope => "write"
end