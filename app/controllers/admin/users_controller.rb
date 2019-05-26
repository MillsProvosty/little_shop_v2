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

  def update
    @user = User.find(params[:id])
    @user.update_column(:role, "merchant")
    flash[:message] = "#{@user.name} has been upgraded to Merchant status"
    redirect_to admin_merchant_path(@user)
  end

end
