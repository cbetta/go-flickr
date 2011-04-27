class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :url
      t.boolean :uploaded, :default => false
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
