class UsersController < ApplicationController
  def new
    @new_user = User.new
  end

  def create
    user = User.new(user_params)
      if user.save
        session[:user_id] = user.id
        flash[:welcome] = "Congratulations #{user.name}! You are now registered and logged in."
        redirect_to user_profile_path(user)
      else
        flash[:message] = "Unable to register user. Missing required fields"
        redirect_to new_user_path
      end
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
