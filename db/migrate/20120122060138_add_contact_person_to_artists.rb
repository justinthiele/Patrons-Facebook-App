class AddContactPersonToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :contact_person, :string
  end

  def self.down
    remove_column :artists, :contact_person
  end
end
