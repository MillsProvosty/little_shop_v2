class Admin::MerchantsController < ApplicationController

  def show
    @merchant = User.find(params[:id])
    @top_five_items = current_user.top_items_for_merchant
  end

  def index
    @merchants = User.where(role: :merchant)
  end
end
