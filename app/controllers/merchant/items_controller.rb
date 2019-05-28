class Merchant::ItemsController < Merchant::BaseController
  #all merchant items
  def index
    @merchant = current_user
  end

  def update
    @merchant = current_user
    @item = Item.find(params[:id])
    @item.update_column(:active, false)
    flash[:message] = "#{@item.name} is no longer for sale."
    redirect_to merchant_items_path
  end
end
