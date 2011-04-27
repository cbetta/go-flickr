class AddFullyAuthorisedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fully_authorised, :boolean, :default => false
  end

  def self.down
    remove_column :users, :fully_authorised
  end
end
