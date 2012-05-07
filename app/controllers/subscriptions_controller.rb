class SubscriptionsController < ApplicationController
  # GET /subscriptions
  # GET /subscriptions.xml
  # def index
  #   @subscriptions = Subscription.all
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @subscriptions }
  #   end
  # end

  # GET /subscriptions/1
  # GET /subscriptions/1.xml
  # def show
  #   @local_subscription = Subscription.find(params[:id])
  #   @plan = @local_subscription.plan
  #   @customer_token = @local_subscription.stripe_customer_token
  #   @subscription = Stripe::Customer.retrieve("#{@customer_token}")
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @subscription }
  #   end
  # end

  # GET /subscriptions/new
  # GET /subscriptions/new.xml
  def new
    if session[:current_user].present?
      @plan = Plan.find(params[:plan_id])
      @subscription = @plan.subscriptions.build
    else
      if current_facebook_user
        session[:current_user] = current_facebook_user.id
        @plan = Plan.find(params[:plan_id])
        @subscription = @plan.subscriptions.build
      else
        flash[:error] = "You must authorize with Facebook"
        redirect_to :back
      end
    end
  end


  # GET /subscriptions/1/edit
  def edit
    
    if session[:current_user] == Subscription.find(params[:id]).user.facebook_user_id
      @subscription = Subscription.find(params[:id])
    end
  end

  # POST /subscriptions
  # POST /subscriptions.xml
  def create
    @subscription = Subscription.new(params[:subscription])
    if @subscription.save_with_payment
      # do a search to find if the user exists - if not create a new one
      @user = User.where(:facebook_user_id => @subscription.facebook_user_id).first
      
      if @user.blank?
        @user = User.new
        @user.email = @subscription.email
        @user.facebook_user_id = @subscription.facebook_user_id
        @user.save
        @subscription.update_attributes(:user_id => @user.id)
        redirect_to user_profile_url(@subscription.user), :notice => "Thank you for making your pledge to #{@subscription.plan.artist.name}!"
      else
        @subscription.update_attributes(:user_id => @user.id)
        redirect_to user_profile_url(@subscription.user), :notice => "Thank you for making your pledge to #{@subscription.plan.artist.name}!"
      end
      Notifier.new_pledge_artist(@subscription).deliver
      Notifier.new_pledge_user(@subscription).deliver
    else
      render :new
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.xml
  def update

    if session[:current_user] == Subscription.find(params[:id]).user.facebook_user_id  
      @subscription = Subscription.find(params[:id])
      if @subscription.update_card(params[:subscription][:stripe_card_token])
        redirect_to(user_profile_url(@subscription.user), :notice => 'Your credit card has been updated.')        
      else
        render :edit  
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.xml
  def destroy
    
    @local_subscription = Subscription.find(params[:id])
    @customer_token = @local_subscription.stripe_customer_token
    @subscription = Stripe::Customer.retrieve("#{@customer_token}")
    @subscription.cancel_subscription
    Notifier.subscription_deleted_user(@local_subscription).deliver
    Notifier.subscription_deleted_artist(@local_subscription).deliver
    Notifier.subscription_deleted_us(@local_subscription).deliver
    @local_subscription.destroy

    respond_to do |format|
      format.html { redirect_to(user_profile_url(@local_subscription.user), :notice => 'Your pledge has been cancelled.') }
      format.xml  { head :ok }
    end
  end
end
