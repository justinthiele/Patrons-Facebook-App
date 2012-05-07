class CreatePaymentNotifications < ActiveRecord::Migration
  def self.up
    create_table :payment_notifications do |t|
      t.integer :plan_id
      t.integer :user_id
      t.string :status
      t.integer :amount
      t.text :raw_response

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_notifications
  end
end
