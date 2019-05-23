class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        flash[:welcome] = "Congratulations #{@user.name}! You are now registered and logged in."
        redirect_to user_profile_path(@user)
      elsif User.find_by(email: user_params[:email])
        flash[:message] = "Email address is already in use"
        @user.email = ""
        render :new
      else
        flash[:message] = "Unable to register user. Missing required fields"
        render :new
      end
  end


  def show
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password)
    end
end
