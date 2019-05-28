class Merchant::ItemsController < Merchant::BaseController
  #all merchant items
  def index
    @merchant = current_user
  end
end
