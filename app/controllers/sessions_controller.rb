class SessionsController < ApplicationController
  skip_before_filter :authorize
  def new
  end

  def create
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.cart
        session[:cart_id] = user.cart.id
      else
        user.cart = current_cart
      end
      
      if user.name == 'admin'
        session[:admin_id] = user.id
        redirect_to store_url
      else
        redirect_to store_url
      end
      
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:cart_id] = nil
    session[:admin_id] = nil
    session[:cart_mode] = nil
    redirect_to store_url, notice: "Logged out"
  end
end