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
  # two or three random items in specified study.
  # Also, if user has recently compared these items, say so.
  def assign
    begin
      study = Study.find(params[:study_id])
      @items = Item.where(study_id: study.id)
      
      if @items.size < study.n_way
        redirect_to(studies_path)
        return
      end
      
      if study.n_way == 3
        item_id1 = rand(@items.size)
        item_id2 = rand(@items.size)
        while item_id1 == item_id2
          item_id2 = rand(@items.size)
        end
        item_id3 = rand(@items.size)
        while item_id1 == item_id3 || item_id2 == item_id3
          item_id3 = rand(@items.size)
        end
        
        comparisons = []
        Comparison.where(user_id: session[:user_id], study_id: params[:study_id]).each do |c|
          rank1 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id1].id)
          rank2 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id2].id)
          rank3 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id3].id)
          if rank1 && rank2 && rank3
            comparisons << c
          end        
        end
        c = comparisons.max
        if c
          rank1 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id1].id).rank
          rank2 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id2].id).rank
          rank3 = Rank.find_by(comparison_id: c.id, item_id: @items[item_id3].id).rank
          
          if rank1 > rank2
            temp = rank1
            rank1 = rank2
            rank2 = temp
            
            temp = item_id1
            item_id1 = item_id2
            item_id2 = temp
          end
          
          if rank2 > rank3
            temp = rank2
            rank2 = rank3
            rank3 = temp
            
            temp = item_id2
            item_id2 = item_id3
            item_id3 = temp
          end
          
          if rank1 > rank2
            temp = rank1
            rank1 = rank2
            rank2 = temp
            
            temp = item_id1
            item_id1 = item_id2
            item_id2 = temp
          end
          
          notice = "You recently ranked #{@items[item_id1].name} "
          if rank1 < rank2
            notice = notice + "above "
          else
            notice = notice + "the same as "
          end
          notice = notice + "#{@items[item_id2].name}, which you ranked "
          if rank2 < rank3
            notice = notice + "above "
          else
            notice = notice + "the same as "
          end
          notice = notice + "#{@items[item_id3].name}."
          flash[:notice] = notice
        end
        
        redirect_to(show_three_way_comparison_path(@items[item_id1].id, @items[item_id2].id, @items[item_id3].id))
      else
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
          
          if rank1 > rank2
            temp = rank1
            rank1 = rank2
            rank2 = temp
            
            temp = item_id1
            item_id1 = item_id2
            item_id2 = temp
          end
          
          if rank1 != rank2
            flash[:notice] = "You recently ranked #{@items[item_id1].name} above #{@items[item_id2].name}."
          else
            flash[:notice] = "You recently said you were not sure whether #{@items[item_id1].name} or #{@items[item_id2].name} is better."
          end
        end
        
        redirect_to(show_two_way_comparison_path(@items[item_id1].id, @items[item_id2].id))
      end
    rescue
      redirect_to(studies_path)
    end
  end
  
  # If authenticated, and if items are valid and study is active,
  # show comparison view for two items.
  def show_two_way
    begin
      @item1 = Item.find(params[:item_id1])
      @item2 = Item.find(params[:item_id2])
      study = Study.find(@item1.study_id)
      
      if study.n_way != 2
        redirect_to(studies_path)
        return
      end
    
      if @item1 == @item2 || @item1.study_id != @item2.study_id || study.active == false
        redirect_to(studies_path)
        return
      end
      
      @undo = false
    
      @study_name = study.name
      @ncomparisons = Comparison.where(user_id: session[:user_id], study_id: study.id).size
    rescue
      redirect_to(studies_path)
    end
  end
  
  def show_three_way
    begin
      @item1 = Item.find(params[:item_id1])
      @item2 = Item.find(params[:item_id2])
      @item3 = Item.find(params[:item_id3])
      study = Study.find(@item1.study_id)
      
      if study.n_way != 3
        redirect_to(studies_path)
        return
      end
    
      if @item1 == @item2 || @item2 == @item3 || @item1 == @item3 || @item1.study_id != @item2.study_id || @item1.study_id != @item3.study_id || study.active == false
        redirect_to(studies_path)
        return
      end
      
      @undo = false
    
      @study_name = study.name
      @ncomparisons = Comparison.where(user_id: session[:user_id], study_id: study.id).size
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
      
      if study.n_way != 2
        redirect_to(studies_path)
        return
      end
      
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
      c.time = Time.new.to_i
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
  
  # If authenticated, and if items are valid and study is active, 
  # and if ranks are valid, 
  # record three-way comparison in database.
  def three_way
    begin
      item1 = Item.find(params[:item_id1])
      item2 = Item.find(params[:item_id2])
      item3 = Item.find(params[:item_id3])
      study = Study.find(item1.study_id)
      
      if study.n_way != 3
        redirect_to(studies_path)
        return
      end
      
      if item1 == item2 || item2 == item3 || item1 == item3 || item1.study_id != item2.study_id || item1.study_id != item3.study_id || study.active == false
        redirect_to(studies_path)
        return
      end
      
      if params[:rank1].to_i < 1 || params[:rank1].to_i > 3 || params[:rank2].to_i < 1 || params[:rank2].to_i > 3 || params[:rank3].to_i < 1 || params[:rank3].to_i > 3
        redirect_to(studies_path)
        return
      end
      
      rank1 = params[:rank1].to_i
      rank2 = params[:rank2].to_i
      rank3 = params[:rank3].to_i
      
      if rank1 > 1 && rank2 > 1 && rank3 > 1
        rank1 = rank1 - 1
        rank2 = rank2 - 1
        rank3 = rank3 - 1
      end
      
      if rank1 > 1 && rank2 > 1 && rank3 > 1
        rank1 = rank1 - 1
        rank2 = rank2 - 1
        rank3 = rank3 - 1
      end
      
      if rank1 != 2 && rank2 != 2 && rank3 != 2
        if rank1 == 3
          rank1 = 2
        end
        if rank2 == 3
          rank2 = 2
        end
        if rank3 == 3
          rank3 = 2
        end
      end
      
      c = Comparison.new
      c.user_id = session[:user_id]
      c.study_id = item1.study_id
      c.time = Time.new.to_i
      c.save
      
      r1 = Rank.new
      r1.comparison_id = c.id
      r1.item_id = item1.id
      r1.rank = rank1.to_i
      r1.save
      
      r2 = Rank.new
      r2.comparison_id = c.id
      r2.item_id = item2.id
      r2.rank = rank2.to_i
      r2.save
      
      r3 = Rank.new
      r3.comparison_id = c.id
      r3.item_id = item3.id
      r3.rank = rank3.to_i
      r3.save
      
      redirect_to(assign_comparison_path(item1.study_id))
    rescue
      redirect_to(studies_path)
    end
  end
end