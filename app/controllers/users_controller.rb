class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  #def index
  #  @users = User.all

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.xml  { render :xml => @users }
  #  end
  #end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @title = @user.username

    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @title = "Sign Up"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.twitter = ''
    @user.website = ''
    @user.location = ''
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        session[:user_id] = @user.id
        format.html { redirect_to(@user) }
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

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:reg_notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def login
    if(session[:user_id])
      @user = User.find_by_id(session[:user_id])
    else
      @user = User.new
    end
    @title = "Login"
    if request.post?
      user = User.authenticate(params[:username], params[:password])
      if user
        
        session[:user_id] = user.id
        session[:username] = user.username
        uri = session[:original_uri]
        session[:original_uri] = nil
        
        redirect_to(uri || {:controller => "home", :action => "index"})
      else
        #redirect_to(request.request_uri)
        flash.now[:login_notice] = "Invalid user/password!"
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    session[:username] = nil
    redirect_to(:controller => "home", :action => "index")
  end
  
  def setting
    @user = User.find_by_id(session[:user_id])
    @title = "Setting"
  end
end
