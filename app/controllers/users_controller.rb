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
  
  # If email address valid, create a new user if necessary.
  # Then, assign the user a new GUID and send a login link via email.
  def email
    if params[:user_email] == ""
      flash[:error] = "Please enter a valid email address."
      redirect_to(root_path)
      return
    end
    
    begin
      u = User.find_by(email: params[:user_email])
      unless u
        u = User.new
        u.email = params[:user_email]
      end
      
      u.guid = SecureRandom.uuid
      u.save

      Mailer.send_login_email(u, "http://" + request.host_with_port + login_user_path(u.guid)).deliver
      @email = u.email
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
  
  # If authenticated and new email address is valid, 
  # then modify account's email address.
  def modify
    begin
      u = User.find(params[:user_id])
      u.email = params[:user_email]
      u.save
      session[:user_email] = params[:user_email]
    rescue
      flash[:error] = "Please enter a valid email address."
    ensure
      redirect_to(edit_user_path(session[:user_id]))
    end
  end
end