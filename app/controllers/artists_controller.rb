class ArtistsController < ApplicationController

  def show
    
    # parsing the signed_request
      encoded_user_data = params[:signed_request] if params[:signed_request]
  
      if encoded_user_data.blank?
        if params[:id] == "pledge"
          @artist = Artist.find(session[:artist_id])
        else
          @artist = Artist.find(params[:id])
        end
      else    
        # We only care about the data after the '.'
        payload = encoded_user_data.split(".")[1]
      
        # Facebook gives us a base64URL encoded string. Ruby only supports base64 out of the box, so we have to add padding to make it work
        payload += '=' * (4 - payload.length.modulo(4))
      
        decoded_json = Base64.decode64(payload)
        # @signed_data = JSON.parse(decoded_json)
        session[:signed_request] = JSON.parse(decoded_json)
        @signed_data = session[:signed_request]
    
        #end parsing
      
        @artist = Artist.where(:fb_page_id => @signed_data["page"]["id"]).first
        session[:current_user] = @signed_data["user_id"]
      end

    @user = User.where(:facebook_user_id => session[:current_user]).first
    
    if @artist.blank?
      if @signed_data["page"]["admin"] == true
        respond_to do |format|
          format.html { redirect_to(new_artist_url) }
        end
      else
        respond_to do |format|
          format.html { redirect_to(page_path("soon")) }
        end
      end
    else
      @active_plans = @artist.plans.where(:active => "Active").order("price DESC")
      session[:artist_id] = @artist.id
      
      if @artist.published == "true" || @signed_data["page"]["admin"] == true
        respond_to do |format|
          format.html # show.html.erb
          # format.xml  { render :xml => @artist }
        end
      else
        respond_to do |format|
          format.html { redirect_to(page_path("soon")) }
        end
      end
    end
  end

  # GET /artists/new
  # GET /artists/new.xml
  def new
    @artist = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      # format.xml  { render :xml => @artist }
    end
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
  end

  # POST /artists
  # POST /artists.xml
  def create
    @artist = Artist.new(params[:artist])
    @artist.pledges_fee_percent = PLEDGES_FEE_PERCENT
    
    file = open("https://graph.facebook.com/#{params[:artist][:fb_page_id]}")
    graph = JSON.parse(file.read)
    @artist.facebook_page_link = graph["link"]

    respond_to do |format|
      if @artist.save
        session[:artist_id] = @artist.id        
        format.html { redirect_to(artist_profile_url(@artist), :notice => 'Profile created. Now create at least one Pledge Level below.') }
        # format.xml  { render :xml => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /artists/1
  # PUT /artists/1.xml
  def update
    @artist = Artist.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        format.html { redirect_to(artist_profile_url(@artist), :notice => 'Your profile was successfully updated.') }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.xml
  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to(artists_url) }
      # format.xml  { head :ok }
    end
  end
  
  
  # GET /artists/1/profile
  # GET /artists/1/profile.xml
  def profile
    
    @artist = Artist.find(params[:id])
    @plans = @artist.plans.order("price DESC")
    @active_plans = @artist.plans.where(:active => "Active").order("price DESC")
    @inactive_plans = @artist.plans.where(:active => "Inactive").order("price DESC")
    
    # use this instead if you want to run locally while in development:
    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.xml  { render :xml => @artist }
    # end
     
    
    if session[:signed_request]["page"]["id"] == @artist.fb_page_id
      if session[:signed_request]["page"]["admin"] == true
        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @artist }
        end
      else
        respond_to do |format|
          format.html { redirect_to(root_url) }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to(root_url) }
      end
    end        
  end
  
  
  # to toggle published on or off for an artist
  def toggle_published
    @artist = Artist.find(params[:id])
    
    if @artist.published == "true"
      @artist.published = "false"
      @artist.save
      respond_to do |format|
        format.html { redirect_to(artist_profile_url(@artist), :notice => "Your app is no longer published.") }
      end
    else
      @artist.published = "true"
      @artist.save
      respond_to do |format|
        format.html { redirect_to(artist_url(@artist), :notice => "Awesome. Your app is now published to the world.") }
      end
    end
  end
  
  # for the support email form
  def send_support_email
    Notifier.support_email(params[:email]).deliver
    
    flash[:notice] = "Message was sent successfully. We'll be in touch shortly"
    redirect_to :back
  end

end
