class ComparisonsController < ApplicationController
  before_action :authenticate
  
  # If user is not properly authenticated, 
  # e.g., if the user has no GUID, 
  # or if the GUID does not match the user ID in the session,
  # then log the user out.
  def authenticate
    begin
      if !session[:user_guid]
        redirect_to(root_path)
      elsif session[:user_guid] != User.find_by(id: session[:user_id].to_i).guid
        redirect_to(logout_user_path)
      end
    rescue
      redirect_to(logout_user_path)
    end
  end
  
  # If authenticated, redirect to comparison view for 
  # two random items in specified study.
  # Also, if user has recently compared these items, say so.
  def assign
    begin
      @items = Item.where(study_id: params[:study_id])
      
      if @items.size < 2
        redirect_to(studies_path)
        return
      end
      
      item_id1 = rand(@items.size)
      item_id2 = rand(@items.size)
      while item_id1 == item_id2
        item_id2 = rand(@items.size)
      end
      
      comparisons = []
      Comparison.where(user_id: session[:user_id], study_id: params[:study_id]).each do |c|
        rank1 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id1].id)
        rank2 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id2].id)
        if rank1 && rank2
          comparisons << c
        end        
      end
      c = comparisons.max
      if c
        rank1 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id1].id).rank
        rank2 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id2].id).rank
        if rank1 < rank2
          flash[:notice] = "You recently ranked #{@items[item_id1].name} above #{@items[item_id2].name}."
        elsif rank1 > rank2
          flash[:notice] = "You recently ranked #{@items[item_id2].name} above #{@items[item_id1].name}."
        else
          flash[:notice] = "You recently said you were not sure whether #{@items[item_id1].name} or #{@items[item_id2].name} is better."
        end
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
      study = Study.find(@item1.study_id)
    
      if @item1 == @item2 || @item1.study_id != @item2.study_id || study.active == false
        redirect_to(studies_path)
        return
      end
    
      @study_name = study.name
    rescue
      redirect_to(studies_path)
    end
  end
  
  def show_test
    begin
      @item1 = Item.find(params[:item_id1])
      @item2 = Item.find(params[:item_id2])
      @item3 = Item.find(params[:item_id3])
      study = Study.find(@item1.study_id)
    
      if @item1 == @item2 || @item2 == @item3 || @item1 == @item3 || @item1.study_id != @item2.study_id || @item1.study_id != @item3.study_id || study.active == false
        redirect_to(studies_path)
        return
      end
    
      @study_name = study.name
    rescue
      redirect_to(studies_path)
    end
  end
  
  # If authenticated, and if items are valid and study is active, 
  # and if ranks are valid, 
  # record two-way comparison in database.
  def two_way
    begin
      item1 = Item.find(params[:item_id1])
      item2 = Item.find(params[:item_id2])
      study = Study.find(item1.study_id)
      
      if item1 == item2 || item1.study_id != item2.study_id || study.active == false
        redirect_to(studies_path)
        return
      end
      
      if params[:rank1].to_i < 1 || params[:rank1].to_i > 2 || params[:rank2].to_i < 1 || params[:rank2].to_i > 2 || (params[:rank1].to_i == 2 && params[:rank1] == params[:rank2])
        redirect_to(studies_path)
        return
      end
      
      c = Comparison.new
      c.user_id = session[:user_id]
      c.study_id = item1.study_id
      c.save
      
      r1 = Rank.new
      r1.comparison_id = c.id
      r1.item_id = item1.id
      r1.rank = params[:rank1].to_i
      r1.save
      
      r2 = Rank.new
      r2.comparison_id = c.id
      r2.item_id = item2.id
      r2.rank = params[:rank2].to_i
      r2.save
      
      redirect_to(assign_comparison_path(item1.study_id))
    rescue
      redirect_to(studies_path)
    end
  end
end