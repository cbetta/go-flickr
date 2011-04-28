desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  User.where(:fully_authorised => true).update_all_photos 
end