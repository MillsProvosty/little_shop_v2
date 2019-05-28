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
    @merchant.update_column(:active, false)
    flash[:message] = "#{@merchant.name} is now disabled"
    redirect_to admin_merchant_path(@merchant.id)
  end
end
