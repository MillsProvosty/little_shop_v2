class User::UsersController < User::BaseController
  def show

  end

  def edit

  end

  def update
    @user = User.find(current_user.id)
    @user.update(user_update_params)

    if @user.save
      flash[:message] = "Your profile has been updated"
      redirect_to user_path
    else
      flash[:notice] = "This email is already in use"
      render :edit
    end
  end

  def checkout
    order = Order.create(status: "pending", user: current_user)
    cart.associate_items(order)
    cart.clear_cart
    flash[:message] = "Your order was created."
    redirect_to user_orders_path
  end

  def orders
    @orders = current_user.orders
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    binding.pry
    @order.update_attributes(order_delete_params)
    redirect_to user_orders_path
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip)
      .merge(password: params[:user][:password].empty? ? current_user.password_digest : params[:user][:password])
  end

  def order_delete_params
    params.permit(:status)
  end

end
