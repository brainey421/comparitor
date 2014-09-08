class UsersController < ApplicationController
  before_action :authenticate, only: [:edit, :modify]
  
  def authenticate
    if !session[:user_id]
      redirect_to(users_path)
    elsif session[:user_id].to_i != params[:user_id].to_i
      redirect_to(edit_user_path(session[:user_id]))
    end
  end
  
  def index
    if session[:user_id]
      redirect_to(categories_path)
    end
  end
  
  def login
    begin
      unless User.find_by(email: params[:user_email])
        u = User.new
        u.email = params[:user_email]
        u.save
      end
    
      session[:user_id] = User.find_by(email: params[:user_email]).id
      session[:user_email] = params[:user_email]
    rescue
      flash[:notice] = "Please enter a valid email address."
    end
    
    redirect_to(users_path)
  end
  
  def logout
    session[:user_id] = nil
    session[:user_email] = nil
    
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