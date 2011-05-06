desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  User.where(:disabled => nil).update_all(:disabled => true)
  User.where("fully_authorised = ? AND disabled = ?", true, false).update_all_photos 
end