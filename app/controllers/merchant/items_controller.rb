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
    if @item.save
      flash[:message] = "#{@item.name} has been saved."
      redirect_to merchant_items_path
    elsif item_params["name"] == ""
      flash[:message] = "Could not create item without name"
      render :new
    elsif item_params["price"] == ""
      flash[:message] = "Could not create item without a price"
      render :new
    elsif item_params["description"] == ""
      flash[:message] = "Could not create item without a description"
      render :new
    elsif item_params["inventory"] == ""
      flash[:message] = "Could not create item without an inventory value"
      render :new
    elsif item_params[:price].to_i <= 0
      flash[:message] = "Price amount must be greater than zero"
      render :new
    elsif item_params[:inventory].to_i <= 0
      flash[:message] = "Inventory amount must be greater than zero"
      render :new
    end
  end

  def edit
    @merchant = current_user
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:format])
    if @item.update(item_params)
      flash[:message] = "#{@item.name} has been updated"
      redirect_to merchant_items_path
    elsif item_params["price"] == ""
      flash[:message] = "Could not create item without a price"
      render :edit
    elsif item_params[:price].to_i <= 0
      flash[:message] = "Price amount must be greater than zero"
      render :edit
    elsif item_params["inventory"] == ""
      flash[:message] = "Could not create item without an inventory value"
      render :edit
    elsif item_params[:inventory].to_i <= 0
      flash[:message] = "Inventory amount must be greater than zero"
      render :edit
    elsif item_params["name"] == ""
      flash[:message] = "Could not create item without name"
      render :edit
    elsif item_params["description"] == ""
      flash[:message] = "Could not create item without a description"
      render :edit
    else
      render :edit
    end
  end


  def activate_item
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
