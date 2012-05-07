ActiveAdmin.register Artist do
  
  scope :published
  
  index do
    column "Artist Name", :name
    column :contact_person
    column :email
    column :created_at
    column :published
    column :payment_method
    default_actions 
  end
  
end
