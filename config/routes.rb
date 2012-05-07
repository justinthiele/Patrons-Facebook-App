Pledges::Application.routes.draw do
  
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :payment_notifications

  root :to => 'high_voltage/pages#show', :id => 'home'
  
  match '/soon' => 'high_voltage/pages#show', :id => 'soon' 
  match '/faq' => 'high_voltage/pages#show', :id => 'faq' 
  match '/about' => 'high_voltage/pages#show', :id => 'about' 

  
  resources :subscriptions

  match '/users/:id/profile' => 'users#profile', :as => 'user_profile' 
  match '/users/:id/email' => 'users#send_user_support_email', :as => :send_user_support
   
  resources :users

  resources :plans

  match '/artists/:id/profile' => 'artists#profile', :as => 'artist_profile'  
  match '/artists/:id/email' => 'artists#send_support_email', :as => :send_support
  
  match '/artists/toggle-published' => 'artists#toggle_published'
  # match '/artists/export_to_csv' => 'artists#export_to_csv'
  resources :artists
  match '/artists/:signed_request' => 'artists#show'
  
  
  match '/channel', :to => redirect('/public/channel.html')
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
