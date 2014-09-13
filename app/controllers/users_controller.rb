class UsersController < ApplicationController
  before_action :authenticate, only: [:edit, :modify]
  
  def authenticate
    begin
      if !session[:user_guid]
        redirect_to(root_path)
      elsif session[:user_guid] != User.find_by(id: params[:user_id].to_i).guid
        redirect_to(edit_user_path(session[:user_id]))
      end
    rescue
      redirect_to(root_path)
    end
  end
  
  def index
    if session[:user_guid]
      redirect_to(categories_path)
    end
  end
  
  def email
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

      Mailer.send_login_email(u, request.host + ":" + request.port.to_s + login_user_path(u.guid)).deliver
      @email = u.email
    rescue Exception => e  
      puts e.message  
      flash[:notice] = "Please enter a valid email address."
      redirect_to(root_path)
    end
  end
  
  def login
    begin
      if u = User.find_by(guid: params[:user_guid])
        session[:user_id] = u.id
        session[:user_email] = u.email
        session[:user_guid] = u.guid
      else
        flash[:notice] = "To log in, please follow the link sent to you via email."
      end
    rescue
      flash[:notice] = "To log in, please follow the link sent to you via email."
    end
    
    redirect_to(root_path)
  end
  
  def logout
    session[:user_id] = nil
    session[:user_email] = nil
    session[:user_guid] = nil
    
    redirect_to(root_path)
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
      flash[:notice] = "Please enter a valid email address."
    end
    
    redirect_to(edit_user_path(session[:user_id]))
  end
end