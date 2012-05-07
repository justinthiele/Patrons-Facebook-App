ActiveAdmin::Dashboards.build do
  
  
  section "New Artists", :priority => 1 do
    table_for Artist.order("created_at desc").limit(10) do
      column :name do |artist|
        link_to artist.name, [:admin, artist]
      end      
      column :created_at
    end
    strong { link_to "View All Artists", admin_artists_path }
  end
  
  
    section "New Pledges", :priority => 2 do
      table_for Subscription.order("created_at desc").limit(10) do
        column :user do |subscription|
          subscription.user.email
        end
        column :artist do |subscription|
          subscription.plan.artist.name
        end
        column :monthly_pledge do |subscription|
          number_to_currency subscription.price
        end
      end
    end
    
    
    section "App Response Time", :priority => 3 do
      div do
        br
        %{<iframe src="https://heroku.newrelic.com/public/charts/hHCqxIuoehv" width="500" height="300" scrolling="no" frameborder="no"></iframe>}.html_safe
      end
    end
    
    
    section "Recent Payment Notifications", :priority => 4 do
      table_for PaymentNotification.order("created_at desc").limit(10) do
        column :user do |payment_notification|
          payment_notification.user.email if payment_notification.user.present?
        end
        column :artist do |payment_notification|
          payment_notification.plan.artist.name if payment_notification.plan.present?
        end
        column :monthly_pledge do |payment_notification|
          number_to_currency payment_notification.amount/100 if payment_notification.amount.present?      
        end
        column :status
        column :created_at
      end
    end
    

  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
