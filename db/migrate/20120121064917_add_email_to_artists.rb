class AddEmailToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :email, :string
  end

  def self.down
    remove_column :artists, :email
  end
end
