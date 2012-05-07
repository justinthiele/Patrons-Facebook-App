ActiveAdmin.register User do
  
  index do
    column :name
    column :email
    column :number_of_pledges do |user|
      user.subscriptions.count
    end
    column :created_at
    default_actions 
    
  end
  
  
end
