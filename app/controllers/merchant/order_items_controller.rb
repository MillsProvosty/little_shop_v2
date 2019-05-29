class Merchant::OrderItemsController < Merchant::BaseController

  def update
    item_id = params[:id]
    order_id = params[:order_id]
    @order = Order.find(order_id)
    @orderitem = OrderItem.find_row_by(order_id, item_id)
    @orderitem.fulfilled = true
    @orderitem.save
    item = Item.find(item_id)
    item.inventory -= @orderitem.quantity
    item.save
    if @order.order_items.all? { |order_item| order_item.fulfilled == true }
      @order.status = "packaged"
      @order.save
    end

    flash[:message] = "Item fulfilled"
    redirect_to merchant_order_path(order_id)
  end

end
