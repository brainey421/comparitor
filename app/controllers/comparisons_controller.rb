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
      @members = Member.where(category_id: params[:category_id])
      member_id1 = rand(@members.size)
      member_id2 = rand(@members.size)
      while member_id1 == member_id2
        member_id2 = rand(@members.size)
      end
      redirect_to(show_comparison_path(@members[member_id1], @members[member_id2]))
    rescue
      redirect_to(categories_path)
    end
  end
  
  def show
    begin
      @member1 = Member.find(params[:member_id1])
      @member2 = Member.find(params[:member_id2])
    
      if @member1 == @member2 || @member1.category_id != @member2.category_id
        redirect_to(categories_path)
        return
      end
    
      @category_name = Category.find(@member1.category_id).name
    rescue
      redirect_to(categories_path)
    end
  end
end