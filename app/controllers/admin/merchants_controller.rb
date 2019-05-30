class Admin::MerchantsController < Admin::BaseController


  def show
    user = User.find(params[:id])
    if user.role == "user"
      redirect_to admin_user_path(user)
    end

    @merchant = User.find(params[:id])
    @top_five_items = current_user.top_items_for_merchant
  end

  def index
    @merchants = User.where(role: :merchant)
  end

  def update
    @merchant = User.find(params[:id])
    if @merchant.active
      @merchant.update_column(:active, false)
      flash[:message] = "#{@merchant.name} is now disabled"
      redirect_to admin_merchants_path
    elsif !@merchant.active
      @merchant.update_column(:active, true)
      flash[:message] = "#{@merchant.name} is now enabled"
      redirect_to admin_merchants_path
    end
  end

  def downgrade
    @merchant = User.find(params[:id])
    @merchant.disable_items
    @merchant.update_column(:role, "user")
    flash[:message] = "#{@merchant.name} has been downgraded to a regular user"
    redirect_to admin_user_path(@merchant)
  end
end
