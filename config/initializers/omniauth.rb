Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gowalla, ENV['GWPHOTOS_GOWALLA_KEY'], ENV['GWPHOTOS_GOWALLA_SECRET']
end