class SessionsController < ApplicationController

  def new
    if current_user && current_user.role == "user"
      flash[:message] = "Welcome #{current_user.name}, you are already logged in."
      redirect_to user_profile_path(current_user)
    elsif current_user && current_user.role == "merchant"
      flash[:message] = "Welcome #{current_user.name}, you are already logged in."
      redirect_to merchant_dashboard_path(current_user)
    elsif current_user && current_user.role == "admin"
      flash[:message] = "Welcome #{current_user.name}, you are already logged in."
      redirect_to items_path
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password]) && user.role == "user"
      session[:user_id] = user.id
      flash[:login] = "Welcome back #{user.name}, you are logged in."
      redirect_to user_profile_path(user)
    elsif user.authenticate(params[:password]) && user.role == "merchant"
      session[:user_id] = user.id
      flash[:login] = "Welcome back #{user.name}, you are logged in."
      redirect_to merchant_dashboard_path(user)
    elsif user.authenticate(params[:password]) && user.role == "admin"
      session[:user_id] = user.id
      flash[:login] = "Welcome back #{user.name}, you are logged in."
      redirect_to items_path
    else
      render :new
    end
  end

end
