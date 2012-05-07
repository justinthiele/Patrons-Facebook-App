class PaymentNotificationsController < ApplicationController
    
  protect_from_forgery :except => [:create]  
  
  # These are the New Stripe webhook notifications
  # POST /payment_notifications
  def create
    # retrieve the request's body and parse it as JSON
    event_json = JSON.parse(request.body.read)    

    # for extra security
    parsed_params = Stripe::Event.retrieve(event_json['id'])
    
    # worked
    # parsed_params = Stripe::Event.retrieve("evt_kMHeF9JmNG0nNx")
    
        
        if Subscription.where(:stripe_customer_token => parsed_params["data"]["object"]["customer"]).exists?

          
          subscription = Subscription.where(:stripe_customer_token => parsed_params["data"]["object"]["customer"]).first
          if parsed_params["type"] == 'charge.succeeded'
              payment_notification = PaymentNotification.create!(:raw_response => parsed_params, :amount => parsed_params["data"]["object"]["amount"].to_i, :status => parsed_params["type"], :plan_id => subscription.plan_id, :user_id => subscription.user_id, :stripe_id => parsed_params["id"])
              Notifier.recurring_pledge_user(payment_notification).deliver
          elsif parsed_params["type"] == 'charge.failed'
              payment_notification = PaymentNotification.create!(:raw_response => parsed_params, :amount => parsed_params["data"]["object"]["amount"].to_i, :status => parsed_params["type"], :plan_id => subscription.plan_id, :user_id => subscription.user_id, :stripe_id => parsed_params["id"])
              Notifier.recurring_payment_failed_us(payment_notification).deliver
              Notifier.recurring_payment_failed_user(payment_notification).deliver
          elsif parsed_params["type"] == 'charge.disputed'
              payment_notification = PaymentNotification.create!(:raw_response => parsed_params, :amount => parsed_params["data"]["object"]["amount"].to_i, :status => parsed_params["type"], :plan_id => subscription.plan_id, :user_id => subscription.user_id, :stripe_id => parsed_params["id"])
              Notifier.payment_disputed_us(payment_notification).deliver
              # TODO: send an email to the user and maybe the artist too
          elsif parsed_params["type"] == 'customer.subscription.deleted'
              #turns out this block doesn't get called because the subscription is already deleted at this point and customer ID isn't found
              payment_notification = PaymentNotification.create!(:raw_response => parsed_params, :amount => parsed_params["data"]["object"]["plan"]["amount"].to_i, :status => parsed_params["type"], :plan_id => subscription.plan_id, :user_id => subscription.user_id, :stripe_id => parsed_params["id"])
              # Notifier.subscription_deleted_us(payment_notification).deliver
              # TODO: send confirmation to the user and maybe an update to the artist
          else
              # unrecognized event
                PaymentNotification.create!(:raw_response => parsed_params, :status => parsed_params["type"], :plan_id => subscription.plan_id, :user_id => subscription.user_id, :stripe_id => parsed_params["id"])
          end
     
        else
            # user not found
            if parsed_params["type"] == 'customer.created' || parsed_params["type"] == 'customer.subscription.deleted'
              # these are common reasons why the user might not be found on the webhook
              payment_notification = PaymentNotification.create!(:raw_response => parsed_params, :status => parsed_params["type"], :stripe_id => parsed_params["id"])
            else
              # get notified of any weird reasons why a user isn't found
              payment_notification = PaymentNotification.create!(:raw_response => parsed_params, :status => parsed_params["type"], :stripe_id => parsed_params["id"])
              Notifier.user_not_found_us(payment_notification).deliver
            end
        end
        
    render :nothing => true
    
    
  end
  
  
    
  
  
  
  
  # These are the Legacy Stripe webhook notifications
  # POST /payment_notifications
  # def create    
  #     parsed_params = JSON.parse(params["json"])
  #     if Subscription.where(:stripe_customer_token => parsed_params["customer"]).exists?
  #       user = Subscription.where(:stripe_customer_token => parsed_params["customer"]).first.user_id
  #     
  #       if parsed_params["event"] == "recurring_payment_succeeded"
  #           payment_notification = PaymentNotification.create!(:raw_response => parsed_params, :amount => parsed_params["invoice"]["total"].to_i, :status => parsed_params["event"], :plan_id => parsed_params["invoice"]["lines"]["subscriptions"].first["plan"]["id"].to_i, :user_id => user)
  #           Notifier.recurring_pledge_user(payment_notification).deliver
  #           render :nothing => true
  #       elsif parsed_params["event"] == "recurring_payment_failed"
  #           payment_notification = PaymentNotification.create!(:raw_response => parsed_params, :amount => parsed_params["invoice"]["total"].to_i, :status => parsed_params["event"], :plan_id => parsed_params["invoice"]["lines"]["subscriptions"].first["plan"]["id"].to_i, :user_id => user)
  #           Notifier.recurring_payment_failed_us(parsed_params).deliver
  #           # TODO: send an email to the user and maybe the artist too
  #           render :nothing => true
  #       elsif parsed_params["event"] == "subscription_final_payment_attempt_failed"
  #           payment_notification = PaymentNotification.create!(:raw_response => parsed_params, :amount => parsed_params["subscription"]["plan"]["amount"].to_i, :status => parsed_params["event"], :plan_id => parsed_params["subscription"]["plan"]["id"].to_i, :user_id => user)
  #           Notifier.subscription_final_payment_attempt_failed_us(parsed_params).deliver
  #           # TODO: send an email to the user and maybe the artist too
  #           render :nothing => true        
  #       else
  #           # unrecognized event
  #           # Notifier.unrecognized_stripe_event_us(parsed_params).deliver
  #           render :nothing => true
  #       end
  #     
  #     else
  #       # user not found
  #       Notifier.user_not_found_us(parsed_params).deliver
  #       render :nothing => true
  #     end
  # end  


end
