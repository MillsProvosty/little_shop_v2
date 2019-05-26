class CartsController < ApplicationController
  before_action :confirm_user_or_visitor

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

  def add_item
    whats_available = Item.find(params[:id]).inventory
    whats_in_cart = session[:cart][params[:id]]

    increment_item_in_cart if whats_in_cart < whats_available
    redirect_to cart_path
  end

  def eliminate_item
    eliminate_item_in_cart
    whats_in_cart = session[:cart][params[:id]]

    if whats_in_cart < 1
      cart.delete_item(params[:id])
    end

    redirect_to cart_path
  end

  def destroy

    session.delete(:cart)

    redirect_to cart_path
  end

  def delete_item
    session[:cart].delete(params[:id])

    redirect_to cart_path
  end

  def increment_item_in_cart
    session[:cart][params[:id].to_s] += 1
  end

  def eliminate_item_in_cart
    session[:cart][params[:id].to_s] -= 1
  end

  private

  def confirm_user_or_visitor
    redirect_to('/404') unless current_user? or !current_user
  end
end
