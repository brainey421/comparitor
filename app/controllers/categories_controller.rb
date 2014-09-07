class CategoriesController < ApplicationController
  def index
    unless session[:user_id]
      redirect_to(root_path)
    end
    
    @categories = Category.find_each
  end
end