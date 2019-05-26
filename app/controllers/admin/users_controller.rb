class Admin::UsersController < ApplicationController

  def index
    if current_admin?
    @users = User.reg_users
    else
    render_404
    end
  end

  def show
    @user = User.find(params[:id])
  end

end
