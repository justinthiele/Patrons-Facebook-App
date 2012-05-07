class Artist < ActiveRecord::Base
  
  has_many :plans, :dependent => :destroy
  
  validates :name, :presence => true
  validates :email, :presence => true
  validates :headline, :presence => true
  
  mount_uploader :image, ImageUploader
  
  scope :published, where(:published => "true")
  
end
