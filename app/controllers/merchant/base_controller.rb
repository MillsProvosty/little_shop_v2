class Merchant::BaseController < ApplicationController
  before_action :confirm_merchant

  private
  def confirm_merchant
    render file: '/public/404', status: 404 unless current_merchant?
  end
end
