class MerchantsController < ApplicationController
  def index
    if current_admin?
      @merchants = User.where(role: 1)
    else
      @merchants = User.active_merchants
    end
  end
end
