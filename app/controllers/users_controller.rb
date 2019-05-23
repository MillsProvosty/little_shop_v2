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
      else
        flash[:message] = "Unable to register user. Missing required fields"
        render :new
      end
  end

  def show

  end

  def edit

  end

  def update
    @user = User.find(current_user.id)
    @user.update!(user_update_params)
    redirect_to user_profile_path(@user)
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password)
    end

    def user_update_params
      params.require(:user).permit(:name, :email, :address, :city, :state, :zip).merge(password: params[:user][:password].empty? ? current_user.password_digest : params[:user][:password])
    end
end
