class CategoriesController < ApplicationController
  def index
    unless session[:user_id]
      redirect_to(root_path)
    end
    
    @categories = Category.find_each
  end
  
  def show
    unless session[:user_id]
      redirect_to(root_path)
    end
    
    begin
      @category = Category.find(params[:category_id])[:name]
      @items = Item.where(category_id: params[:category_id])
    rescue
      redirect_to(categories_path)
    end
  end
end