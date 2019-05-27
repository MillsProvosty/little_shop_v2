class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find(params[:id])
    @items = @order.items_from_merchant(current_user.id)
  end
end

