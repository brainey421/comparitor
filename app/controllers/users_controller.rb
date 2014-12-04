class UsersController < ApplicationController
  before_action :authenticate, only: [:edit, :modify]
  
  # If user is not properly authenticated, 
  # e.g., if the user has no GUID, 
  # if the GUID does not match the user ID in the session,
  # or the GUID does not match the user ID in the parameter, 
  # then log the user out.
  def authenticate
    begin
      if !session[:user_guid]
        redirect_to(root_path)
      elsif session[:user_guid] != User.find_by(id: session[:user_id].to_i).guid
        redirect_to(logout_user_path)
      elsif session[:user_guid] != User.find_by(id: params[:user_id].to_i).guid
        redirect_to(logout_user_path)
      end
    rescue
      redirect_to(logout_user_path)
    end
  end
  
  # If user is not logged in, display login page.
  # Otherwise, redirect to the list of active studies.
  def index
    if session[:user_guid]
      redirect_to(comparitor_path)
    end
  end
  
  # If user already exists, redirect to email path. 
  # Otherwise, present the create account form.
  def create
    if params[:user_email] == ""
      flash[:error] = "Please enter a valid email address."
      redirect_to(root_path)
      return
    end
    
    @email = params[:user_email]
    
    begin
      u = User.find_by(email: @email)
      if u
        redirect_to(email_user_path(user_email: @email))
        return
      end
    rescue
      flash[:error] = "Please enter a valid email address."
      redirect_to(root_path)
    end
  end
  
  # If email address valid, create a new user if necessary.
  # Then, assign the user a new GUID and send a login link via email.
  def email
    net0 = IPAddr.new("128.10.0.0/16")
    net1 = IPAddr.new("128.46.0.0/16")
    net2 = IPAddr.new("128.210.0.0/16")
    net3 = IPAddr.new("128.211.0.0/16")
    net4 = IPAddr.new("204.52.32.0/19")
    net5 = IPAddr.new("192.5.40.0/24")
    net6 = IPAddr.new("192.5.101.0/24")
    net7 = IPAddr.new("192.5.102.0/24")
    net8 = IPAddr.new("192.31.0.0/24")
    
    if net0 === request.remote_ip || net1 === request.remote_ip || net2 === request.remote_ip || net3 === request.remote_ip.to_s || net4 === request.remote_ip || net5 === request.remote_ip || net6 === request.remote_ip || net7 === request.remote_ip || net8 === request.remote_ip
      flash[:error] = "Please login on the Purdue West Lafayette campus."
      redirect_to(root_path)
      return
    end
    
    if params[:user_email] == ""
      flash[:error] = "Please enter a valid email address."
      redirect_to(root_path)
      return
    end
    
    @email = params[:user_email]
    
    begin
      u = User.find_by(email: @email)
      if u
        u.guid = SecureRandom.uuid
        u.save
      else
        if params[:user_name] == ""
          flash[:error] = "Please enter a valid first name."
          redirect_to(create_user_path(user_email: @email))
          return
        end
        
        u = User.new
        u.email = @email
        u.name = params[:user_name]
        u.guid = SecureRandom.uuid
        u.save
      end
      
      Mailer.send_login_email(u, "http://" + request.host_with_port + login_user_path(u.guid)).deliver
    rescue
      flash[:error] = "Please enter a valid email address."
      redirect_to(root_path)
    end
  end
  
  # If GUID is valid, store user's ID, email, and GUID in the session.
  # Otherwise, redirect to login page.
  def login
    begin
      u = User.find_by(guid: params[:user_guid])
      session[:user_id] = u.id
      session[:user_email] = u.email
      session[:user_guid] = u.guid
      session[:user_name] = u.name
    rescue
      flash[:error] = "Please log in again, and follow the link sent to you via email."
    ensure
      redirect_to(root_path)
    end
  end
  
  # Reset GUID if possible. 
  # Then, clear the information from the session.
  def logout
    begin
      u = User.find(session[:user_id])
      u.guid = SecureRandom.uuid
      u.save
    rescue
      
    ensure
      flash[:notice] = "When you log in next time, we'll send you a new login link via email."
    
      session[:user_id] = nil
      session[:user_email] = nil
      session[:user_guid] = nil
      session[:user_name] = nil
      
      redirect_to(root_path)
    end
  end
  
  # If authenticated, display edit account page, 
  # including user statistics.
  def edit
    begin
      @ncomparisons = Comparison.where(user_id: params[:user_id]).size
    rescue
      redirect_to(root_path)
    end
  end
  
  # If authenticated and new email address and name are valid, 
  # then modify account's email address and name.
  def modify
    begin
      u = User.find(params[:user_id])
      unless params[:user_email] == ""
        u.email = params[:user_email]
        session[:user_email] = params[:user_email]
      end
      unless params[:user_name] == ""
        u.name = params[:user_name]
        session[:user_name] = params[:user_name]
      end
      u.save
    rescue
      flash[:error] = "Please enter a valid email address."
    ensure
      redirect_to(edit_user_path(session[:user_id]))
    end
  end
end