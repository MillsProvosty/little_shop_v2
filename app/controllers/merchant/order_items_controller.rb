class Merchant::OrderItemsController < Merchant::BaseController

  def update
    item_id = params[:id]
    order_id = params[:order_id]
    @orderitem = OrderItem.find_row_by(order_id, item_id)
    @orderitem.fulfilled = true
    @orderitem.save
    item = Item.find(item_id)
    item.inventory -= @orderitem.quantity
    item.save
    flash[:message] = "Item fulfilled"
    redirect_to merchant_order_path(order_id)
  end

end
