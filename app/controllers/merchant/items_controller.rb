class Merchant::ItemsController < Merchant::BaseController
  #all merchant items
  def index
    @merchant = current_user
  end

  def update
    @merchant = current_user
    @item = Item.find(params[:id])
    if @item.active == true
    @item.update_column(:active, false)
    flash[:message] = "#{@item.name} is no longer for sale."
    redirect_to merchant_items_path
    elsif @item.active == false
    @item.update_column(:active, true)
    flash[:message] = "#{@item.name} is now for sale."
    redirect_to merchant_items_path
    end
  end
end
