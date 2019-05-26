class Merchant::BaseController < ApplicationController
  before_action :confirm_merchant

  private
  def confirm_merchant
    redirect_to('/404') unless current_merchant?
  end
end
