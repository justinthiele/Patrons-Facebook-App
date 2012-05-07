class AddEmailToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :email, :string
  end

  def self.down
    remove_column :subscriptions, :email
  end
end
