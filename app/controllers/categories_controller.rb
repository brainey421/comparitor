class CategoriesController < ApplicationController
  before_action :authenticate
  
  def authenticate
    begin
      if !session[:user_guid]
        redirect_to(logout_user_path)
      elsif session[:user_guid] != User.find_by(id: session[:user_id].to_i).guid
        redirect_to(logout_user_path)
      end
    rescue
      redirect_to(logout_user_path)
    end
  end
  
  def index
    @categories = Category.find_each
  end
  
  def show
    begin
      @category = Category.find(params[:category_id])[:name]
      @items = Item.where(category_id: params[:category_id])
    rescue
      redirect_to(categories_path)
    end
  end
end