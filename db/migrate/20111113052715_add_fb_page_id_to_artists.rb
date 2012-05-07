class AddFbPageIdToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :fb_page_id, :string
  end

  def self.down
    remove_column :artists, :fb_page_id
  end
end
