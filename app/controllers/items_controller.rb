class ItemsController < ApplicationController
  def index
    @items = Item.active_items
    @top_five = Item.top_five
    @bottom_five = Item.bottom_five
  end

  def show
    @item = Item.find(params[:id])
  end
end
