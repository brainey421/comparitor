class ComparisonsController < ApplicationController
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
  
  def assign
    begin
      @items = Item.where(category_id: params[:category_id])
      item_id1 = rand(@items.size)
      item_id2 = rand(@items.size)
      while item_id1 == item_id2
        item_id2 = rand(@items.size)
      end
      redirect_to(show_comparison_path(@items[item_id1], @items[item_id2]))
    rescue
      redirect_to(categories_path)
    end
  end
  
  def show
    begin
      @item1 = Item.find(params[:item_id1])
      @item2 = Item.find(params[:item_id2])
    
      if @item1 == @item2 || @item1.category_id != @item2.category_id
        redirect_to(categories_path)
      end
    
      @category_name = Category.find(@item1.category_id).name
    rescue
      redirect_to(categories_path)
    end
  end
end