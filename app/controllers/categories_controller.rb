class CategoriesController < ApplicationController
  before_action :authenticate
  
  def authenticate
    if !session[:user_id]
      redirect_to(root_path)
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