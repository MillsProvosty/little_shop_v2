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

  def show
    if cart.contents == {}
      flash[:message] = "Cart is Empty"
    end
  end

  def destroy

    session.delete(:cart)

    redirect_to cart_path
  end

  def delete_item
    session[:cart].delete(params[:id])

    redirect_to cart_path
  end

end
