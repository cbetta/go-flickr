require "heroku"

desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  User.where(:fully_authorised => true).update_all_photos
  client = Heroku::Client.new(ENV['HEROKU_USER'], ENV['HEROKU_PASSWORD'])
  client.set_workers(ENV['HEROKU_APP'], 0) 
end