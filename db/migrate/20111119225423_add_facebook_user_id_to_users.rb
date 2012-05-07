class AddFacebookUserIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_user_id, :string
  end

  def self.down
    remove_column :users, :facebook_user_id
  end
end
