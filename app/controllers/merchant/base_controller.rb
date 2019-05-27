class Merchant::BaseController < ApplicationController
  before_action :confirm_merchant_or_admin

  private
  def confirm_merchant_or_admin
    redirect_to('/404') unless current_merchant? || current_admin?
  end

end
