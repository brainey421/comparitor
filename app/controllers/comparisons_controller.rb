class ComparisonsController < ApplicationController
  def assign
    @items = Item.where(category_id: params[:category_id])
    redirect_to(show_comparison_path(@items[0], @items[1]))
  end
  
  def show
    @item1 = Item.find(params[:item_id2])
    @item2 = Item.find(params[:item_id1])
    
    @category_name = Category.find(@item1.category_id).name
  end
end