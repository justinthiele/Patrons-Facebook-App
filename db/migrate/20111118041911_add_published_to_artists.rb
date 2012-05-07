class AddPublishedToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :published, :string
  end

  def self.down
    remove_column :artists, :published
  end
end
