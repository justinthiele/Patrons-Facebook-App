class AddFacebookPageLinkToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :facebook_page_link, :string
  end

  def self.down
    remove_column :artists, :facebook_page_link
  end
end
