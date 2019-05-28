class Admin::MerchantsController < ApplicationController

  def show
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
end
