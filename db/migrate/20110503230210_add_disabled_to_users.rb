class AddDisabledToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :disabled, :boolean, :default => false
    User.all.each do |user|
      user.disabled = false
      user.save
    end
  end

  def self.down
    remove_column :users, :disabled
  end
end
