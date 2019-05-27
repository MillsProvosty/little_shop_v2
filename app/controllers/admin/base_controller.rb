class Admin::BaseController < ApplicationController
  before_action :confirm_admin

  private
  def confirm_admin
    redirect_to ('/404') unless current_admin?
  end
end
