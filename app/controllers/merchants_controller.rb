class MerchantsController < ApplicationController
  def index
      @merchants = User.active_merchants
      @topthreesellers = User.topthreesellers
      @topthreetimes = User.topthreetimes
      @worstthreetimes = User.worstthreetimes
      @topthreestates = User.topthreestates

  end
end
