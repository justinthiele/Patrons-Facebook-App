class Plan < ActiveRecord::Base

  validates :name, :presence => true
  validates :price, :presence => true
  
  belongs_to :artist
  has_many :subscriptions
  has_many :payment_notifications

end
