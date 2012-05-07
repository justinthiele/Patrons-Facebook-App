ActiveAdmin.register Plan do
  
  index do
    
    column :artist do |plan|
      plan.artist.name
    end
    column "Plan Name", :name
    column :price
    column :created_at
    column "Active?", :active
    default_actions 
  end
  
end
