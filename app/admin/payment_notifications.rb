ActiveAdmin.register PaymentNotification do 
  
  index do
    column :user
    column :artist do |payment_notification|
      payment_notification.plan.artist.name if payment_notification.plan.present?
    end
    column :plan
    column :status
    column :amount, :sortable => :amount do |payment_notification|
      number_to_currency payment_notification.amount/100 if payment_notification.amount.present?
    end
    column :raw_response
    column :created_at
    default_actions 
  end

  
end