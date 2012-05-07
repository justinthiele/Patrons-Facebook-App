class PlansController < ApplicationController
  # GET /plans
  # GET /plans.xml
  # def index
  #   @plans = Plan.all
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @plans }
  #   end
  # end

  # GET /plans/1
  # GET /plans/1.xml
  # def show
  #   @plan = Plan.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @plan }
  #   end
  # end

  # GET /plans/new
  # GET /plans/new.xml
  def new
    @plan = Plan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @plan }
    end
  end

  # GET /plans/1/edit
  def edit
    @plan = Plan.find(params[:id])
    @active = params[:active]
    
  end

  # POST /plans
  # POST /plans.xml
  def create
    @plan = Plan.new(params[:plan])
    @plan.transaction_fee_percent = TRANSACTION_FEE_PERCENT
    @plan.transaction_fee_flat = TRANSACTION_FEE_FLAT
    @plan.artist_id = session[:artist_id]    

    respond_to do |format|
      if @plan.save

        Stripe::Plan.create( :amount => "#{(@plan.price * 100).to_i}", :interval => 'month', :name => "#{@plan.artist.name} - #{@plan.name}", :currency => 'usd', :id => "#{@plan.id}" )
        
        format.html { redirect_to(artist_profile_url(@plan.artist), :notice => 'Pledge level was successfully created.') }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        format.html { redirect_to(artist_profile_url(@plan.artist), :notice => 'Pledge level was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to(plans_url) }
      format.xml  { head :ok }
    end
  end
end
