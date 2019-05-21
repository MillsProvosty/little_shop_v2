class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:email])
    # binding.pry
    if user.authenticate(params[:password]) && user.role == "user"
      session[:user_id] = user.id
      redirect_to user_profile_path(user)
    elsif user.authenticate(params[:password]) && user.role == "merchant"
      session[:user_id] = user.id
      redirect_to merchant_dashboard_path(user)
    else
      render :new
    end
  end

end
