class UsersController < ApplicationController
  before_action :authenticate, only: [:edit, :modify]
  
  def authenticate
    begin
      if !session[:user_guid]
        redirect_to(logout_user_path)
      elsif session[:user_guid] != User.find_by(id: session[:user_id].to_i).guid
        redirect_to(logout_user_path)
      elsif session[:user_guid] != User.find_by(id: params[:user_id].to_i).guid
        redirect_to(logout_user_path)
      end
    rescue
      redirect_to(logout_user_path)
    end
  end
  
  def index
    if session[:user_guid]
      redirect_to(studies_path)
    end
  end
  
  def email
    if params[:user_email] == ""
      flash[:error] = "Please enter a valid email address."
      redirect_to(root_path)
      return
    end
    
    begin
      u = User.find_by(email: params[:user_email])
      if u
        u.guid = SecureRandom.uuid
        u.save
      else
        u = User.new
        u.email = params[:user_email]
        u.guid = SecureRandom.uuid
        u.save
      end

      Mailer.send_login_email(u, "http://" + request.host_with_port + login_user_path(u.guid)).deliver
      @email = u.email
    rescue
      flash[:error] = "Please enter a valid email address."
      redirect_to(root_path)
    end
  end
  
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
  
  def edit
    
  end
  
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