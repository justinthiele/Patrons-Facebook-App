ActiveAdmin.register Subscription do
  
  index do
    column :user
    column :artist do |subscription|
      subscription.plan.artist.name
    end
    column :plan
    column :price
    column :created_at
    default_actions 
  end
  
end
