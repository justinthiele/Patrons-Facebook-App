class User < ActiveRecord::Base
  
  has_many :subscriptions, :dependent => :destroy
  has_many :payment_notifications
  
  # validates :name, :presence => true
  validates :email, :presence => true
  
    
end
