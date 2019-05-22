class SessionsController < ApplicationController

  def new
    if current_user?
      flash[:message] = "Welcome #{current_user.name}, you are already logged in."
      redirect_to user_profile_path(current_user)
    elsif current_merchant?
      flash[:message] = "Welcome #{current_user.name}, you are already logged in."
      redirect_to merchant_dashboard_path(current_user)
    elsif current_admin?
      flash[:message] = "Welcome #{current_user.name}, you are already logged in."
      redirect_to items_path
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if !user || !user.authenticate(params[:password])
      flash[:message] = "Your credentials were incorrect."
      redirect_to login_path
    else
      session[:user_id] = user.id
      flash[:login] = "Welcome back #{user.name}, you are logged in."

      if current_user?
        redirect_to user_profile_path(user)
      elsif current_merchant?
        redirect_to merchant_dashboard_path(user)
      elsif current_admin?
        redirect_to items_path
      end
    end
  end
end
