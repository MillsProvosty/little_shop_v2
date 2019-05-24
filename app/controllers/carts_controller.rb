class CartsController < ApplicationController

  def create
    @item = Item.find(params[:item_id])
    @cart = Cart.new(session[:cart])

    item_id_str = @item.id.to_s
    session[:cart] ||= Hash.new(0)
    session[:cart][item_id_str] ||= 0
    session[:cart][item_id_str] = session[:cart][item_id_str] + 1
    flash[:notice] = "You now have #{session[:cart][item_id_str]} #{@item.name} added to cart."
    redirect_to items_path
  end

end
