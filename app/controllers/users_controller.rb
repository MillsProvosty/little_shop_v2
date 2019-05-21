class UsersController < ApplicationController
  def new
    @new_user = User.new
  end

  def create
    user = User.new(user_params)
    user.save
    redirect_to user_profile_path(user)
  end

  def index;end

  def show
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password)
    end
end
