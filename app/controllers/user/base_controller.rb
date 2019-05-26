class User::BaseController < ApplicationController
  before_action :confirm_user

  private
  def confirm_user
    redirect_to('/404') unless current_user?
  end
end
