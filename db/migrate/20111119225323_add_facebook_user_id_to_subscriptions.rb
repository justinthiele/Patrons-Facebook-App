class AddFacebookUserIdToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :facebook_user_id, :string
  end

  def self.down
    remove_column :subscriptions, :facebook_user_id
  end
end
