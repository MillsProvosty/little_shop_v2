class Merchant::ItemsController < Merchant::BaseController
  #all merchant items
  def index
    @merchant = current_user
  end

  def new
    @merchant = current_user
    @item = Item.new
  end

  def create
    @merchant = current_user
    @item = Item.new(item_params)
    @item.active = true
    @merchant.items << @item
    if @item.save!
      flash[:message] = "#{@item.name} has been saved."
      redirect_to merchant_items_path
    else
      render :new
    end
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

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:message] = "#{@item.name} has been deleted."
    redirect_to merchant_items_path
  end

  private

  def item_params
    params.require(:item).permit(:name, :price, :description, :image, :inventory)
  end
end
