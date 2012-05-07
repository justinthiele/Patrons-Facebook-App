class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  # def index
  #   @users = User.all
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @users }
  #   end
  # end

  # GET /users/1
  # GET /users/1.xml
  # def show
  #   @user = User.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @user }
  #   end
  # end

  # GET /users/new
  # GET /users/new.xml
  # def new
  #   @user = User.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @user }
  #   end
  # end

  # GET /users/1/edit
  def edit
    if session[:current_user] == User.find(params[:id]).facebook_user_id
      @user = User.find(params[:id])
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    
    if session[:current_user] == @user.facebook_user_id
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to user_profile_url(@user), :notice => "Your has been updated." }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to(root_url) }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    
    if session[:current_user] == @user.facebook_user_id
      @user.destroy
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to(root_url) }
      end
    end 
  end
  
  # GET /users/1/profile
  # GET /users/1/profile.xml
  def profile
    
    @user = User.find(params[:id])  
    
    if session[:current_user] == @user.facebook_user_id
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    else
      respond_to do |format|
        format.html { redirect_to(root_url) }
      end
    end
  end
  
  # for the support email form
  def send_user_support_email
    Notifier.user_support_email(params[:email]).deliver
    
    flash[:notice] = "Message was sent successfully. We'll be in touch shortly"
    redirect_to :back
  end

end
