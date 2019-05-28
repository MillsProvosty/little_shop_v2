class Admin::OrdersController < Admin::BaseController

    def update
      @order = Order.find(params[:id])
      @order.status = "shipped"
      @order.save
      redirect_to admin_dashboard_path
    end
end
