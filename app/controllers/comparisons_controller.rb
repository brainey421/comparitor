class ComparisonsController < ApplicationController
  before_action :authenticate
  
  # If user is not properly authenticated, 
  # e.g., if the user has no GUID, 
  # or if the GUID does not match the user ID in the session,
  # then log the user out.
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
  
  # If authenticated, redirect to comparison view for 
  # two random items in specified study.
  def assign
    begin
      @items = Item.where(study_id: params[:study_id])
      item_id1 = rand(@items.size)
      item_id2 = rand(@items.size)
      while item_id1 == item_id2
        item_id2 = rand(@items.size)
      end
      redirect_to(show_comparison_path(@items[item_id1].id, @items[item_id2].id))
    rescue
      redirect_to(studies_path)
    end
  end
  
  # If authenticated, and if items are valid and study is active,
  # show comparison view for two items.
  def show
    begin
      @item1 = Item.find(params[:item_id1])
      @item2 = Item.find(params[:item_id2])
    
      if @item1 == @item2 || @item1.study_id != @item2.study_id || Study.find(@item1.study_id).active == false
        redirect_to(studies_path)
        return
      end
    
      @study_name = Study.find(@item1.study_id).name
    rescue
      redirect_to(categories_path)
    end
  end
end