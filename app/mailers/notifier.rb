class Notifier < ActionMailer::Base
  default :from => "\"Patrons\" <hello@patrons.us>"  

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.new_pledge_artist.subject
  #
  def welcome_new_artist(artist)
    @artist = artist
    mail :to => @artist.email, :subject => "Welcome To Patrons"
  end

  def new_pledge_artist(subscription)
    @subscription = subscription
    @user = @subscription.user
    mail :to => @subscription.plan.artist.email, :subject => "Woot! New Supporter: #{@user.email}"
  end
  
  def new_pledge_user(subscription)
    @subscription = subscription
    @artist = @subscription.plan.artist
    mail :to => @subscription.user.email, :subject => "Woot! You Made A Pledge To #{@artist.name}"
  end
  
  def recurring_pledge_user(payment_notification)
    @payment_notification = payment_notification
    @artist = @payment_notification.plan.artist
    mail :to => @payment_notification.user.email, :subject => "Success! You've Made Your Monthly Pledge To #{@artist.name} :)"
  end
  
  def recurring_payment_failed_us(payment_notification)
    @payment_notification = payment_notification
    mail :to => "support@patrons.us", :subject => "Uh oh. Failed Payment: #{@payment_notification.user.email}"
  end

  def recurring_payment_failed_user(payment_notification)
    @payment_notification = payment_notification
    @artist = @payment_notification.plan.artist
    mail :to => @payment_notification.user.email, :subject => "Your Monthly Pledge To #{@artist.name} Failed :("
  end


  
  def payment_disputed_us(payment_notification)
    @payment_notification = payment_notification
    mail :to => "support@patrons.us", :subject => "Uh oh. Payment Disputed: #{@payment_notification.user.email}"
  end  

  def subscription_final_payment_attempt_failed_us(parsed_params)
    @parsed_params = parsed_params
    mail :to => "support@patrons.us", :subject => "d'ah! Final Payment Attempt Failed: #{@parsed_params["customer"]}"
  end

  def subscription_deleted_us(local_subscription)
    @local_subscription = local_subscription
    mail :to => "support@patrons.us", :subject => "d'ah! Pledge Canceled: #{@local_subscription.user.email}"
  end

  def subscription_deleted_user(local_subscription)
    @local_subscription = local_subscription
    mail :to => @local_subscription.user.email, :subject => "Ok, your pledge to #{@local_subscription.plan.artist.name} has been canceled."
  end

  def subscription_deleted_artist(local_subscription)
    @local_subscription = local_subscription
    mail :to => @local_subscription.plan.artist.email, :subject => "Pledge Canceled: #{@local_subscription.user.email}"
  end

  def unrecognized_stripe_event_us(parsed_params)
    @parsed_params = parsed_params
    mail :to => "support@patrons.us", :subject => "Hmm... Unrecognized Stripe Event: #{@parsed_params["customer"]}"
  end
  
  def user_not_found_us(payment_notification)
    @payment_notification = payment_notification
    mail :to => "support@patrons.us", :subject => "Hmm... User not found for Stripe Event"
  end
  
  def support_email(email_params, sent_at = Time.now)
    subject "Artist Support Request: " << email_params[:subject]
    recipients "support@patrons.us"
    from email_params[:address]
    sent_on sent_at
    body :message => email_params[:body], :sender_name => email_params[:name], :sender_email => email_params[:address], :fb_page_id => email_params[:fb_page_id]
  end

  def user_support_email(email_params, sent_at = Time.now)
    subject "Fan Support Request: " << email_params[:subject]
    recipients "support@patrons.us"
    from email_params[:address]
    sent_on sent_at
    body :message => email_params[:body], :sender_name => email_params[:name], :sender_email => email_params[:address], :fb_user_id => email_params[:fb_user_id]
  end

end
