class Admin::AdminController < Admin::BaseController

  def show
    @all_orders_sorted = Order.sort_by_status
  end
end
