class AddBacklogProcessedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :backlog_processed, :boolean, :default => false
    User.all.each do |user|
      user.backlog_processed = true
      user.save
    end
  end

  def self.down
    remove_column :users, :backlog_processed
  end
end
