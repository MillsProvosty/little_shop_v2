class Merchant::MerchantsController < Merchant::BaseController

  def show
    @top_five_items = current_user.top_items_for_merchant
    @merchant = current_user
  end

end
