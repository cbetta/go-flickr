class AddProcessedToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :processed, :boolean, :default => false
    Photo.all.each do |photo|
      photo.processed = photo.uploaded
      photo.save
    end
  end

  def self.down
    remove_column :photos, :processed
  end
end
