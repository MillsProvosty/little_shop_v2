class MerchantsController < ApplicationController
  def index
      @merchants = User.active_merchants
      @topthreesellers = User.topthreesellers

  end
end
