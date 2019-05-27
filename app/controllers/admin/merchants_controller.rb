class Admin::MerchantsController < ApplicationController

  def show
    @merchant = User.find(params[:id])
    @top_five_items = @merchant.top_items_for_merchant
  end
end
