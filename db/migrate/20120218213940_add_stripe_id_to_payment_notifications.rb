class AddStripeIdToPaymentNotifications < ActiveRecord::Migration
  def self.up
    add_column :payment_notifications, :stripe_id, :string
  end

  def self.down
    remove_column :payment_notifications, :stripe_id
  end
end
