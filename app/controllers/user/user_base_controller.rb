class User::BaseController < ApplicationController
  before_action :confirm_user

  private
  def confirm_user
    render file: '/public/404', status: 404 unless current_user?
  end
end
