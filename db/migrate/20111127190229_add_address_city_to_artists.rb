class AddAddressCityToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :address_city, :string
  end

  def self.down
    remove_column :artists, :address_city
  end
end
